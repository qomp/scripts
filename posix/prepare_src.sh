#!/bin/bash

#COLORS
pink="\x1B[01;91m"
green="\e[0;32m"
blue="\x1B[01;94m"
nocolor="\x1B[0m"
#

homedir=$HOME
qomp_git=https://github.com/qomp/qomp.git
srcdir=${homedir}/build
projectdir=${srcdir}/qomp

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

exclude_cmd="--exclude=.git/* --exclude=.git*"

echo -e "${blue}Fetching qomp sources into${nocolor} ${pink}${srcdir}${nocolor}"
get_src
ver=$(sed -n '/[^_]APPLICATION_VERSION/p' ${projectdir}/libqomp/src/defines.h | cut -d '"' -f 2 | sed "s/\s/-/")
cd ${srcdir}
echo -e "${blue}Creating tarball archive${nocolor}"
tar -pczf ${srcdir}/qomp-${ver}.tar.gz ${exclude_cmd} qomp
echo -e "${blue}Tarball file${nocolor} ${pink}qomp-${ver}.tar.gz${nocolor} ${blue}created in${nocolor} ${pink}${srcdir}${nocolor}"
