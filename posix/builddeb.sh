#!/bin/bash
homedir=$HOME
srcdir=${homedir}/build
projectdir=${srcdir}/qomp
builddir=${srcdir}/tmpbuild
exitdir=${srcdir}/debians
data=`LANG=en date +'%a, %d %b %Y %T %z'`
year=`date +'%Y'`
prefix="usr/local"
project=""
section=""
arch="all"
depends=""
description=""
descriptionlong=""
addit=""
builddep=""
docfiles=""
dirs=""
CWDIR=`pwd`
isloop=1

if [ ! -z $USERNAME ]
then
	username=$USERNAME
else 
	if [ ! -z $USER ]
	then
		username=$USER
	else
		exit 0
	fi
fi

if [ ! -z $HOST ]
then
	hostname=$HOST
else 
	if [ ! -z $HOSTNAME ]
	then
		hostname=$HOSTNAME
	else
		exit 0
	fi
fi

Maintainer="${username} <${username}@${hostname}>"

quit ()
{
	isloop=0
}

check_dir ()
{
	if [ ! -z "$1" ]
	then
		if [ ! -d "$1" ]
		then
			tmpdir=$1			
			echo "making directory $tmpdir..."
			cd ${srcdir}
			mkdir -p "$tmpdir"
		fi
	fi
}

clean_build ()
{
	if [ ! -z "$1" ]
	then
		if [ -d "$1" ]
		then
			rm -r "$1"
		fi
	fi
}

rm_all ()
{
	cd ${homedir}
	if [ -d "${srcdir}" ]
	then
		rm -rf ${srcdir}
	fi
}

get_src ()
{
	cd ${homedir}
	check_dir ${srcdir}
	cd ${srcdir}
	if [ ! -d "${projectdir}" ]
	then
		git clone https://code.google.com/p/qomp/ ${projectdir}
	else
		cd ${projectdir}
		git pull
	fi

}

build_deb ()
{
	dpkg-buildpackage -rfakeroot
}

#
prepare_specs ()
{
changelog="${project} (${ver}-1) unstable; urgency=low

  * new upsream release

 -- ${username} <${username}@gmail.com>  ${data}"

compat="7"
control="Source: ${project}
Section: ${section}
Priority: extra
Maintainer: ${Maintainer}
Build-Depends: ${builddep}
Standards-Version: 3.8.1
Homepage: https://code.google.com/p/qomp/

Package: ${project}
Architecture: ${arch}
${addit}
Depends: ${depends}
Description: ${description}
 ${descriptionlong}
"
copyright="This package was debianized by:

    ${Maintainer} on ${data}

It was downloaded from:

    https://code.google.com/p/qomp/

Upstream Author(s):

    Khryukin Evgeny <wadealer@gmail.com>

License:

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This package is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

On Debian systems, the complete text of the GNU General
Public License version 3 can be found in \"/usr/share/common-licenses/GPL-3\".

The Debian packaging is:

    Copyright (C) ${year} ${Maintainer} 

and is licensed under the GPL version 3, see above.

# Please also look if there are files or directories which have a
# different copyright/license attached and list them here.
"
docs=${docfiles}

rules_qt='#!/usr/bin/make -f
# -*- makefile -*-
# Sample debian/rules that uses debhelper.
# This file was originally written by Joey Hess and Craig Small.
# As a special exception, when this file is copied by dh-make into a
# dh-make output file, you may use that output file without restriction.
# This special exception was added by Craig Small in version 0.37 of dh-make.

# Uncomment this to turn on verbose mode.
#export DH_VERBOSE=1
config.status: configure
	dh_testdir

	# Add here commands to configure the package.
	./configure --host=$(DEB_HOST_GNU_TYPE)
	--build=$(DEB_BUILD_GNU_TYPE)
	--prefix=/usr 
  
include /usr/share/cdbs/1/rules/debhelper.mk
include /usr/share/cdbs/1/class/qmake.mk

# Add here any variable or target overrides you need.
QMAKE=qmake-qt4
CFLAGS=-O3
CXXFLAGS=-O3'

	echo "${rules_qt}" > rules
	echo "${changelog}" > changelog
	echo "${compat}" > compat
	echo "${control}" > control
	echo "${copyright}" > copyright
	echo "${docs}" > docs
	echo "${dirs}" > dirs
}
#

build_qomp ()
{
	clean_build ${builddir}
	check_dir ${builddir}
	get_src
	project="qomp"
	ver="0.1-beta"
	debdir=${builddir}/${project}-${ver}
	check_dir ${debdir}
	cp -rf ${projectdir}/* ${debdir}/
	cd ${debdir}
	section="sound"
	arch="any"
	builddep="debhelper (>= 7), cdbs, libqt4-dev, libphonon-dev"
	addit="#"
	depends="\${shlibs:Depends}, \${misc:Depends}, libphonon4, libc6 (>=2.7-1), libgcc1 (>=1:4.1.1), libstdc++6 (>=4.1.1), libx11-6, zlib1g (>=1:1.1.4), libarchive12"
	description="Quick(Qt) Online Music Player"
	descriptionlong='Quick(Qt) Online Music Player - one player for different online music hostings.'
	docfiles="README
LICENSE.txt"
	
	dirs="${prefix}/bin
${prefix}/share/icons/hicolor/128x128/apps
${prefix}/share/icons/hicolor/16x16/apps
${prefix}/share/icons/hicolor/24x24/apps
${prefix}/share/icons/hicolor/48x48/apps
${prefix}/share/icons/hicolor/64x64/apps
${prefix}/share/icons/hicolor/32x32/apps
${prefix}/share/applications"
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs
	cd ${debdir}
	qmake qomp.pro
	build_deb
	check_dir ${exitdir}
	cp -f ${builddir}/*.deb	${exitdir}/
}

print_menu ()
{
  local menu_text='Choose action TODO!
[1] - Build qomp debian package
[2] - Remove all sources
[0] - Exit'
  echo "${menu_text}"
}

choose_action ()
{
	read vibor
	case ${vibor} in
		"1" ) build_qomp;;
		"2" ) rm_all;;
		"0" ) quit;;
	esac
}

clear
while [ ${isloop} = 1 ]
do
  print_menu
  choose_action
done
exit 0
