#!/bin/bash
homedir=$HOME
srcdir=${homedir}/build
projectdir=${srcdir}/qomp
builddir=${srcdir}/tmpbuild
exitdir=${srcdir}/debians
data=$(LANG=en date +'%a, %d %b %Y %T %z')
if [ "$(lsb_release -is)" == "Ubuntu" ]; then
	oscodename=$(lsb_release -cs)
else
	oscodename="unstable"
fi
year=$(date +'%Y')
PREFIX=/usr
qomphomepage=http://qomp.sourceforge.net/
pprefix="usr"
project="qomp"
section="sound"
arch="any"
depends=""
description=""
descriptionlong=""
addit=""
builddep=""
docfiles=""
dirs=""
CWDIR=$(pwd)
build_count=1
isloop=1

#GIT REPO URI
qomp_git=https://github.com/qomp/qomp.git
themes_git=https://github.com/qomp/themes.git

#COLORS
pink="\x1B[01;91m"
green="\e[0;32m"
blue="\x1B[01;94m"
nocolor="\x1B[0m"
#

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

Maintainer="KukuRuzo <thetvg@gmail.com>"

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
			echo -e "${blue}making directory${nocolor} ${pink}$tmpdir...${nocolor}"
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
	fetch_from_git() {
		if [ ! -d "$2" ]; then
			git clone $1 $2
			cd $2
			git submodule init
			git submodule update
		else
			cd $2
			git reset --hard
			git pull
			git submodule update
			git pull
		fi
	}
	cd ${homedir}
	check_dir ${srcdir}
	cd ${srcdir}
	fetch_from_git ${qomp_git} ${projectdir}
	cd ${srcdir}
	#fetch_from_git ${themes_git} ${srcdir}/themes
	#cd ${srcdir}
}

build_deb ()
{
	dpkg-buildpackage -rfakeroot
}

#
prepare_specs ()
{
changelog="${project} (${ver}-${build_count}) ${oscodename}; urgency=low

${changelogtext}

 -- ${username} <thetvg@gmail.com>  ${data}"

compat="7"
control="Source: ${project}
Section: ${section}
Priority: extra
Maintainer: ${Maintainer}
Build-Depends: ${builddep}
Standards-Version: 3.8.1
Homepage: ${qomphomepage}

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

    ${qomphomepage}

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

rules_qt="#!/usr/bin/make -f
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

  
include /usr/share/cdbs/1/rules/debhelper.mk
include /usr/share/cdbs/1/class/cmake.mk

# Add here any variable or target overrides you need.
DEB_CMAKE_EXTRA_FLAGS += ${cmake_flags}
CFLAGS=-O2 -pthread
CXXFLAGS=-O2 -pthread
"
rules_themes="#!/usr/bin/make -f
# -*- makefile -*-

#export DH_VERBOSE=1
config.status: configure
	dh_testdir

include /usr/share/cdbs/1/rules/debhelper.mk
include /usr/share/cdbs/1/class/qmake.mk
QMAKE = qmake -qt=5 PREFIX=/usr
"

	if [ "${project}" == "qomp" ]; then
		echo "${rules_qt}" > rules
		echo "${docs}" > docs
	else
		echo "${rules_themes}" > rules
	fi
	echo "${changelog}" > changelog
	echo "${compat}" > compat
	echo "${control}" > control
	echo "${copyright}" > copyright
	echo "${dirs}" > dirs
}
#

set_vars ()
{
	builddep="debhelper (>= 7), cdbs, libqt4-dev, libphonon-dev, libphononexperimental-dev, libtag1-dev, libcue-dev, libqjson-dev, pkg-config, cmake"
	addit="#"
	depends="\${shlibs:Depends}, \${misc:Depends}, libphonon4, phonon-backend-gstreamer, libqt4-core, libqt4-gui, libqt4-dbus, libqt4-opengl, libqt4-xml, libssl1.0.0, libc6 (>=2.7-1), libgcc1 (>=1:4.1.1), libstdc++6 (>=4.1.1), libx11-6, zlib1g (>=1:1.1.4)"
	description="Quick(Qt) Online Music Player"
	descriptionlong='Quick(Qt) Online Music Player - one player for different online music hostings.'
	docfiles="README
LICENSE.txt"
	
	dirs="${pprefix}/bin
${pprefix}/share/icons/hicolor/128x128/apps
${pprefix}/share/icons/hicolor/16x16/apps
${pprefix}/share/icons/hicolor/24x24/apps
${pprefix}/share/icons/hicolor/48x48/apps
${pprefix}/share/icons/hicolor/64x64/apps
${pprefix}/share/icons/hicolor/32x32/apps
${pprefix}/share/applications
${pprefix}/share/qomp
${pprefix}/share/qomp/plugins
${pprefix}/share/qomp/translations"
	cmake_flags="-DCMAKE_INSTALL_PREFIX=/usr -DUSE_QT5=OFF"
}

set_theme_vars()
{
	builddep="debhelper (>= 7), cdbs, qtbase5-dev"
	addit="#"
	depends="\${shlibs:Depends}, \${misc:Depends}, qomp (>=1.0)"
	description="Quick(Qt) Online Music Player Themes"
	descriptionlong='Themes for Quick(Qt) Online Music Player.'
	dirs="${pprefix}/share/qomp
${pprefix}/share/qomp/themes"
	changelogtext="  * Upstream updated"
}

get_changelog ()
{
	chlfile=${projectdir}/Changelog.txt
	startlog=$(cat ${chlfile} | sed -n '/[0-9]\{4\}$/{n;p;q;}' | sed 's/[[\.*^$/]/\\&/g')
	endlog=$(cat ${chlfile} | sed -n '/^$/{g;1!p;q;};h' | sed 's/[[\.*^$/]/\\&/g')
	changelogtext=$(cat ${chlfile} | sed -n "/${startlog}/,/${endlog}/p" | sed -n 's/^\s*/  /p')
}

get_version()
{
	ver=$(sed -n '/[^_]APPLICATION_VERSION/p' ${projectdir}/libqomp/src/defines.h | cut -d '"' -f 2 | sed "s/\s/-/")
}

prepare_sources()
{
	if [ ! -z "$1" ]; then
		git archive --format=tar HEAD | ( cd $1 ; tar xf - )
		(
		export ddir="$1"
		git submodule foreach "( git archive --format=tar HEAD ) \
		| ( cd \"${ddir}/\${path}\" ; tar xf - )"
		)
	fi
}

build_qomp ()
{
	clean_build ${builddir}
	check_dir ${builddir}
	get_src
	set_vars
	get_version
	get_changelog
	debdir=${builddir}/${project}-${ver}
	check_dir ${debdir}
	cd ${projectdir}
	prepare_sources ${debdir}
	cd ${debdir}
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs
	cd ${debdir}
	build_deb
	check_dir ${exitdir}
	cp -f ${builddir}/*.deb	${exitdir}/
}

build_qomp_qt5 ()
{
	clean_build ${builddir}
	check_dir ${builddir}
	get_src
	set_vars
	project="qomp"
	builddep="debhelper (>= 7), cdbs, qtmultimedia5-dev, qtbase5-dev, qttools5-dev, qttools5-dev-tools, libtag1-dev, libcue-dev, pkg-config, cmake"
	depends="\${shlibs:Depends}, \${misc:Depends}, libssl1.0.0, libc6 (>=2.7-1), libgcc1 (>=1:4.1.1), libstdc++6 (>=4.1.1), libx11-6, zlib1g (>=1:1.1.4)"
	cmake_flags="-DCMAKE_INSTALL_PREFIX=/usr"
	get_version
	get_changelog
	debdir=${builddir}/${project}-${ver}
	check_dir ${debdir}
	cd ${projectdir}
	prepare_sources ${debdir}
	cd ${debdir}
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs
	cd ${debdir}
	build_deb
	check_dir ${exitdir}
	cp -f ${builddir}/*.deb	${exitdir}/
}

build_themes ()
{
	clean_build ${builddir}
	check_dir ${builddir}
	get_src
	project="qomp-themes"
	set_theme_vars
	get_version
	debdir=${builddir}/${project}-${ver}
	check_dir ${debdir}
	cp -rf ${srcdir}/themes/* ${debdir}/
	cd ${debdir}
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs
	cd ${debdir}
	build_deb
	check_dir ${exitdir}
	cp -f ${builddir}/*.deb	${exitdir}/
}

build_i386 ()
{
	get_version
	targetarch=i386
	nameprefix=${project}_${ver}-${build_count}
	dscfile=${builddir}/${nameprefix}.dsc
	srcfile=${builddir}/${nameprefix}.tar.gz
	if [ -f "${dscfile}" ] && [ -f "${srcfile}" ]; then
		sudo DIST=${oscodename} ARCH=${targetarch} pbuilder --build ${dscfile}
		cp -f /var/cache/pbuilder/${oscodename}-${targetarch}/result/${nameprefix}_${targetarch}.deb ${exitdir}/
	fi
}

prepare_pbuilder ()
{
	targetarch=i386
	sudo DIST=${oscodename} ARCH=${targetarch} pbuilder --create
}

print_menu ()
{
	echo -e "${blue}Choose action TODO!${nocolor}
${pink}[1]${nocolor} - Build qomp debian package
${pink}[2]${nocolor} - Build qomp-themes debian package
${pink}[3]${nocolor} - Build qomp debian package with Qt4
${pink}[4]${nocolor} - Remove all sources
${pink}[0]${nocolor} - Exit"
}

choose_action ()
{
	read vibor
	case ${vibor} in
		"1" ) build_qomp_qt5;;
		"2" ) build_themes;;
		"3" ) build_qomp;;
		"11" ) build_i386;; #BUILD i386 VERSION WITH COWBUILDER
		"12" ) prepare_pbuilder;;
		"4" ) rm_all;;
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
