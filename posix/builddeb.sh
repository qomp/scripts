#!/bin/bash
homedir=$HOME
srcdir=${homedir}/build
projectdir=${srcdir}/qomp
builddir=${srcdir}/tmpbuild
exitdir=${srcdir}/debians
develdir=${srcdir}/dev
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
isclean=1
license_ver=2

#GIT REPO URI
qomp_git=https://github.com/qomp/qomp.git

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

Maintainer="Vitaly Tonkacheyev <thetvg@gmail.com>"

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
			git submodule init
			git submodule update
			git pull
		fi
	}
	cd ${homedir}
	check_dir ${srcdir}
	cd ${srcdir}
	fetch_from_git ${qomp_git} ${projectdir}
	cd ${srcdir}
}

build_deb ()
{
	if [ ! -z "$1" ] && [ "$1" == "ppa" ]; then
		debuild -kE48E329C -S
	else
		dpkg-buildpackage -rfakeroot -us -uc
	fi
}

#
prepare_specs ()
{
oldoscodname=${oscodename}
if [ ! -z "$1" ] && [ "$1" == "ppa" ]; then
	echo -e "${pink}Set codename of Ubuntu. [default:${nocolor}${green}${oscodename}${nocolor}${pink}]${nocolor}"
	read oscode
	if [ ! -z "${oscode}" ]; then
		oscodename=${oscode}
	fi
	versuffix="${ver}-0ubuntu1~0ppa${build_count}~${oscodename}"
else
	versuffix="${ver}-${build_count}"
fi
changelog="${project} (${versuffix}) ${oscodename}; urgency=low

${changelogtext}

 -- ${Maintainer}  ${data}"

compat="7"
control="Source: ${project}
Section: ${section}
Priority: extra
Maintainer: ${Maintainer}
Build-Depends: ${builddep}
Standards-Version: 3.9.7
Homepage: ${qomphomepage}

Package: ${project}
Architecture: ${arch}
${addit}
Depends: ${depends}
Description: ${description}
 ${descriptionlong}
"
copyright="This package was debianized by ${Maintainer} on ${data}

It was downloaded from:
    ${qomphomepage}

Upstream Author: Khryukin Evgeny <wadealer@gmail.com>

License:

    qomp is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version ${license_ver} of the License, or
    (at your option) any later version.

    qomp is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    In addition, as a special exception, the copyright holders give
    permission to link the code of portions of this program with the
    OpenSSL library under certain conditions as described in each
    individual source file, and distribute linked combinations
    including the two.
    You must obey the GNU General Public License in all respects
    for all of the code used other than OpenSSL.  If you modify
    file(s) with this exception, you may extend this exception to your
    version of the file(s), but you are not obligated to do so.  If you
    do not wish to do so, delete this exception statement from your
    version.  If you delete this exception statement from all source
    files in the program, then also delete it here.

On Debian systems, the complete text of the GNU General
Public License can be found in \"/usr/share/common-licenses/GPL-${license_ver}\".

The Debian packaging is (C) ${year} ${Maintainer},
and is licensed under the GPL version ${license_ver}, see above.

Copyright 2013-2016 Khryukin Evgeny <wadealer@gmail.com>
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

	echo "${rules_qt}" > rules
	echo "${docs}" > docs
	echo "${changelog}" > changelog
	echo "${compat}" > compat
	echo "${control}" > control
	echo "${copyright}" > copyright
	echo "${dirs}" > dirs
	oscodename=${oldoscodname}
}
#

set_vars ()
{
	builddep="debhelper (>= 7), cdbs, qtmultimedia5-dev, qtbase5-dev, qttools5-dev, libqt5x11extras5-dev, qttools5-dev-tools, libtag1-dev, libcue-dev, pkg-config, cmake"
	addit="#"
	description="Quick(Qt) Online Music Player"
	descriptionlong='Quick(Qt) Online Music Player - one player for different online music hostings.
 main features:
 * search and play music from several online music hostings (Yande.Music, myzuka.ru, pleer.com);
 * play music from local filesystem;
 * Last.fm scrobbling;
 * MPRIS support(Linux only);
 * System tray integration;
 * proxy-server support;
 * playlists support;
 * crossplatform (Windows, OS X, Linux, Android).'
	docfiles="README"
	
	dirs="${pprefix}/bin
${pprefix}/share/icons/hicolor/128x128/apps
${pprefix}/share/icons/hicolor/16x16/apps
${pprefix}/share/icons/hicolor/24x24/apps
${pprefix}/share/icons/hicolor/48x48/apps
${pprefix}/share/icons/hicolor/64x64/apps
${pprefix}/share/icons/hicolor/32x32/apps
${pprefix}/share/applications
${pprefix}/share/qomp
${pprefix}/share/qomp/themes
${pprefix}/share/qomp/translations"
	cmake_flags="-DCMAKE_INSTALL_PREFIX=/usr -DUSE_QT5=OFF"
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
	cd ${builddir}
	tar -zcf ${project}_${ver}.orig.tar.gz *
}

prepare_qt5()
{
	echo -e "${pink}Do you want to clean previous build [y(default)/n]${nocolor}"
	read cleanit
	if [ "${cleanit}" == "n" ]; then
		isclean=0
	else
		isclean=1
	fi
	check_qt_deps
	if [ ${isclean} -eq 1 ]; then
		clean_build ${builddir}
	fi
	check_dir ${builddir}
	get_src
	set_vars
	project="qomp"
	depends="\${shlibs:Depends}, \${misc:Depends}, libqt5multimedia5-plugins, gstreamer1.0-x, gstreamer1.0-libav, gstreamer1.0-plugins-good, libssl1.0.0, libx11-6, zlib1g (>=1:1.1.4)"
	cmake_flags="-DCMAKE_INSTALL_PREFIX=/usr -DUSE_QT5=ON"
	if [ -z "$1" ]; then
		cmake_flags="${cmake_flags} -DUSE_QTCHOOSER=ON"
	fi
	get_version
	get_changelog
	debdir=${builddir}/${project}-${ver}
	check_dir ${debdir}
	cd ${projectdir}
	if [ ! -f ${builddir}/${project}_${ver}.orig.tar.gz ]; then
		prepare_sources ${debdir}
	fi
	cd ${debdir}
	isclean=0
}

check_qt_deps()
{
	check_deps "debhelper cdbs qtmultimedia5-dev libqt5multimedia5-plugins qtbase5-dev qttools5-dev qttools5-dev-tools libtag1-dev libcue-dev pkg-config cmake libqt5x11extras5-dev"
}

build_qomp_qt5 ()
{
	if [ ! -z "$1" ]; then
		prepare_qt5 $1
	else
		prepare_qt5
	fi
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs
	cd ${debdir}
	build_deb
	check_dir ${exitdir}
	check_dir ${exitdir}/dev
	cp -f ${builddir}/*.deb	${exitdir}/
	cp -f ${builddir}/*.dsc	${exitdir}/dev/
	cp -f ${builddir}/*.tar.gz	${exitdir}/dev/
}

build_qomp_ppa()
{
	prepare_qt5 ppa
	clean_build ${develdir}
	check_dir ${debdir}/debian
	cd ${debdir}/debian
	prepare_specs ppa
	cd ${debdir}
	build_deb ppa
	check_dir ${develdir}
	cp -f ${builddir}/*.dsc	${develdir}/
	cp -f ${builddir}/*.orig.tar.gz	${develdir}/
	cp -f ${builddir}/*.diff.gz	${develdir}/
	cp -f ${builddir}/*.build	${develdir}/
	cp -f ${builddir}/*.changes	${develdir}/
}

set_commit()
{
	curr_d=$(pwd)
	print_int_menu()
	{
		echo -e "${blue}Select action to do:${nocolor}
${pink}[1]${nocolor} - View commits${nocolor}
${pink}[2]${nocolor} - Enter commit number${nocolor}
${pink}[0]${nocolor} - Exit from this menu"
	}
	print_log()
	{
		commits=$(cd ${projectdir}; git log --pretty=oneline --abbrev-commit)
		echo -e "${commits}"
		echo -e ""
		echo -e "Current commit $(cd ${projectdir}; git rev-parse --short HEAD)"
	}
	enter_number()
	{
		read ccommit
		if [ ! -z "${ccommit}" ]; then
			cd ${projectdir}
			git checkout ${ccommit}
			git submodule update
		fi
	}
	exit_menu()
	{
		intloop=0
	}
	choose_int_action()
	{
		read choose
		case ${choose} in
		"1" ) print_log;;
		"2" ) enter_number;;
		"0" ) exit_menu;;
	esac
	}
	intloop=1
	while [ ${intloop} = 1 ]
	do
		print_int_menu
		choose_int_action
	done
}

build_i386 ()
{
	check_deps "pbuilder"
	oldcodename=${oscodename}
	get_version
	targetarch=i386
	echo -e "${blue}Set Codename of Ubuntu [default:${nocolor}${green}${oscodename}${nocolor}${blue}]${nocolor}"
	read newcodename
	if [ -z "${newcodename}" ]; then
		newcodename=${oscodename}
	fi
	echo -e "${blue}Set Architecture of Ubuntu [default:${nocolor}${green}${targetarch}${nocolor}${blue}]${nocolor}"
	read newarch
	if [ ! -z "${newarch}" ]; then
		targetarch=${newarch}
	fi
	pbuilder_basename=${homedir}/pbuilder/${newcodename}-${targetarch}-base.tgz
	if [ "$(uname -m)" == "x86_64" ] && [ "${targetarch}" == "amd64" ]; then
		pbuilder_basename=${homedir}/pbuilder/${newcodename}-base.tgz
	else
		if [ "$(uname -m)" == "i686" ] && [ "${targetarch}" == "i386" ]; then
			pbuilder_basename=${homedir}/pbuilder/${newcodename}-base.tgz
		fi
	fi
	if [ ! -f "${pbuilder_basename}" ]; then
		pbuilder-dist ${newcodename} ${targetarch} create
	fi
	currdir=$PWD
	if [ ${isclean} -eq 1 ]; then
		oscodename=${newcodename}
		build_qomp_qt5 i386
	fi
	cd ${builddir}
	dscfile="$(ls | grep .dsc)"
	cd ${currdir}
	echo ${dscfile}
	nameprefix=${dscfile/.dsc}
	if [ -f "${builddir}/${dscfile}" ]; then
		pbuilder-dist ${newcodename} ${targetarch} build ${builddir}/${dscfile}
		cp -f ${pbuilder_basename/-base.tgz}_result/${nameprefix}_${targetarch}.deb ${exitdir}/
	fi
	oscodename=${oldcodename}
}

upload_to_lp()
{
	changesfile="$(cd ${develdir} && ls | grep .changes)"
	cd ${develdir}
	dput ppa:qomp/ppa "${develdir}/${changesfile}"
}

check_deps()
{
	if [ ! -z "$1" ]; then
		instdep=""
		for dependency in $1; do
			echo "${dependency}"
			local result=$(dpkg --get-selections | grep ${dependency})
			if [ -z "${result}" ]; then
				echo -e "${blue}Package ${dependency} not installed. Trying to install...${nocolor}"
				instdep="${instdep} ${dependency}"
			fi
		done
		if [ ! -z "${instdep}" ]; then
			sudo apt-get install ${instdep}
		fi
	fi
}

print_help()
{
	echo -e "${blue}=== Справка: ===${nocolor}
${green}1. Для загрузки пакета на Launchpad:${nocolor}
   необходимо сперва подготовить пакет ${pink}[3]${nocolor},
   а потом загрузить его ppa ${pink}[7]${nocolor}.
   Если нужно загрузить пакет той же версии, но для другой версии системы
   не нужно очищать файлы предыдущей сборки.
${green}2. Для сборки пакета для другой версии системы или другой архитектуры:${nocolor}
   Используйте команду ${pink}[5]${nocolor} и отвечайте на вопросы касательно кодового
   имени системы и архитектуры процессора. В процессе работы команды будет установлен
   pbuilder и содзан образ целевой системы.
${green}3. Создание пакета другой версии:${nocolor}
   Если необходимо создать пакет другой версии, нужно выбрать ${pink}[2]${nocolor}
   и в подменю просмотреть существующие коммиты и указать нужный.
"
}

print_menu ()
{
	echo -e "${blue}Choose action TODO!${nocolor}
${pink}[1]${nocolor} - Build qomp debian package
${pink}[2]${nocolor} - Set build commit
${pink}[3]${nocolor} - Build packages for PPA
${pink}[4]${nocolor} - Remove all sources
${pink}[5]${nocolor} - Build qomp deb-package for another Ubuntu
${pink}[6]${nocolor} - Clean build directory
${pink}[7]${nocolor} - Upload files to Launchpad
${pink}[8]${nocolor} - Show help information
${pink}[0]${nocolor} - Exit"
}

choose_action ()
{
	read vibor
	case ${vibor} in
		"1" ) build_qomp_qt5;;
		"2" ) set_commit;;
		"3" ) build_qomp_ppa;;
		"4" ) rm_all;;
		"5" ) build_i386;; #BUILD i386 VERSION WITH PBUILDER
		"6" ) clean_build ${builddir};;
		"7" ) upload_to_lp;;
		"8" ) print_help;;
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
