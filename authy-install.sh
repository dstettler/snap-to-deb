#!/bin/sh

if [ 0 != $(id -u) ]; then echo "This script must be run as root."; exit 1; fi

pkgname=authy
_snapid="H8ZpNgIoPyvmkgxOWw5MSzsXK1wRZiHn"
_snaprev="11"

src="https://api.snapcraft.io/api/v1/snaps/download/${_snapid}_${_snaprev}.snap"
sha256sums="fdad2931755dee6129ee868dda604826fe6e3afd7343782f7e08b3d572fd6663  ${_snapid}_${_snaprev}.snap"

prep () {
	echo "Downloading snap"
	echo ""
	echo ""

	wget $src
	appsum=$(sha256sum "${_snapid}_${_snaprev}.snap")

	# Check SHASUMS of downloaded .snap file
	if [ "$sha256sums" = "$appsum" ]; then
		echo "sha256sums identical, continuing"
	else
		echo "sha256sums different, stopping execution"
		echo "Assigned sum: $sha256sums"
		echo "Calculated sum: $appsum"
		exit 1
	fi

	mkdir "unsquashed"
	echo "Unpacking filesystem"
	unsquashfs -f -d "unsquashed" "${_snapid}_${_snaprev}.snap"
}

setup () {
	echo ""
	echo "Beginning setup"

	# Establish directory structure
	mkdir "${pkgname}"
	mkdir "${pkgname}/opt"
	mkdir "${pkgname}/usr"
	mkdir "${pkgname}/usr/bin"
	mkdir "${pkgname}/usr/share"
	mkdir "${pkgname}/usr/share/applications"
	mkdir "${pkgname}/usr/share/pixmaps"
	mkdir "${pkgname}/opt/${pkgname}"
	
	# Copy package files to proper directories
	cd "unsquashed"
	cp -rf * "../${pkgname}/opt/${pkgname}"
	cp "meta/gui/icon.png" "../${pkgname}/usr/share/pixmaps/authy.png"
	cp "../authy.desktop" "../${pkgname}/usr/share/applications"
	cd ..

	# Copy package-manager files and prep for packaging
	cp -rf "./DEBIAN" "./${pkgname}"
	chmod 755 "${pkgname}/DEBIAN/postinst"
	chmod 755 "${pkgname}/DEBIAN/postrm"

	# Remove unused files/directories
	rm -rf "${pkgname}/opt/${pkgname}/data-dir"
	rm -rf "${pkgname}/opt/${pkgname}/gnome-platform"
	rm -rf "${pkgname}/opt/${pkgname}/lib"
	rm -rf "${pkgname}/opt/${pkgname}/meta"
	rm -rf "${pkgname}/opt/${pkgname}/scripts"
	rm -rf "${pkgname}/opt/${pkgname}/usr"
	rm -rf "${pkgname}/opt/${pkgname}/*.sh"
}

package () {
	dpkg-deb --build ${pkgname}

	echo "Cleaning up..."
	rm -rf "unsquashed"
	rm -rf "${pkgname}"
	rm "${_snapid}_${_snaprev}.snap"
}

ask_install() {
	echo "Would you like to install now? (Y/n)"
	read installdeb
	case $installdeb in
		"n")
			;;
		"N")
			;;
		*)
			apt install ./${pkgname}.deb
			if [ "$(ls -la "/opt" | grep "authy-deb-generator")" = "" ]; then
		                echo "Would you like to run the apt hook installer? (Y/n)"
               			read installhook
               			case $installhook in
                	        	"n")
                	                	exit 0
                	                	;;
        	                	"N")
	                                	exit 0
                               		 	;;
	                        	*)
        	                        	cd "hook-stuff"
                	        	        ./install-hook.sh
                		                ;;
		                esac
        		fi
	esac
}

prep
setup
package
ask_install
