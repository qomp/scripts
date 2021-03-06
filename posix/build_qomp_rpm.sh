#!/bin/bash
progname=qomp
PREFIX=/usr
homedir=$HOME
builddir=${homedir}/build
rpmbuild_dir=${builddir}/build_${progname}
#Basic build dependencies (SUSE)
builddeps="gcc-c++, zlib-devel, cmake, libcue-devel, libtag-deve, libqt5-qttools-devel, libqt5-qtbase-devel"
#Get OS name
osname=$(cat /etc/os-release | grep ^NAME | cut -d = -f2)
#Fedora build dependencies
if [ "${osname}" == "Fedora" ] || [ "${osname}" == "fedora" ]; then
	builddeps="gcc-c++, zlib-devel, cmake, libcue-devel, taglib-devel, qt5-qttools-devel, qt5-qtbase-devel, qt5-qtmultimedia-devel, qt5-qtx11extras-devel"
fi
#Try to install dependencies
for depitem in $builddeps; do
	depitem=$(echo $depitem | cut -d , -f1)
	if [ "${osname}" == "Fedora" ] || [ "${osname}" == "fedora" ]; then
		sudo dnf install $depitem
	fi
	if [ "${osname}" == "openSUSE" ] || [ "${osname}" == "OPENSUSE" ] || [ "${osname}" == "opensuse" ]; then
		sudo zypper in $depitem
	fi
done

if [ -d "${rpmbuild_dir}" ]
then
	rm -r -f ${rpmbuild_dir}
fi
mkdir -p ${rpmbuild_dir}
qompdir=${builddir}/${progname}
if [ ! -d ${homedir}/rpmbuild ]
then
	cd ${homedir}
	mkdir -p ${homedir}/rpmbuild/SOURCES
	mkdir -p ${homedir}/rpmbuild/SPECS
fi
srcpath=${homedir}/rpmbuild/SOURCES
cd $homedir
if [ ! -d "${qompdir}" ]
then
	git clone https://github.com/qomp/qomp.git ${qompdir}
	cd ${qompdir}
	git submodule init
	git submodule update
else
	cd ${qompdir}
	git reset --hard
	git pull
	git submodule init
	git submodule update
	git pull
fi
cd ${homedir}
defines=${qompdir}/libqomp/src/defines.h
ver=$(grep -o -P "(?<=[^_]APPLICATION_VERSION\s\")[^\s]*(?=\")" $defines)
ver_maj=$(echo $ver | cut -d "." -f1)
ver_min=$(echo $ver | cut -d "." -f2)
ver_patch=$(echo $ver | cut -d "." -f3)
if [ ! "${ver_patch}" ]; then
	ver_patch=0
fi
full_ver=${ver_maj}.${ver_min}.${ver_patch}
package_name=${progname}-${full_ver}.tar.gz
tmpbuilddir=${rpmbuild_dir}/${progname}-${full_ver}
if [ -d "${tmpbuilddir}" ]
then
	rm -rf ${tmpbuilddir}
fi
mkdir -p ${tmpbuilddir}
#cp -rf ${qompdir}/* ${tmpbuilddir}/
cd ${qompdir}
git archive --format=tar HEAD | ( cd ${tmpbuilddir} ; tar xf - )
(
export ddir=${tmpbuilddir}
	git submodule foreach "( git archive --format=tar HEAD ) \
	| ( cd \"${ddir}/\${path}\" ; tar xf - )"
)
cd ${rpmbuild_dir}
tar -pczf ${package_name} ${progname}-${full_ver}
cat <<END >${homedir}/rpmbuild/SPECS/${progname}.spec
Summary: Quick(Qt) Online Music Player
Name: $progname
Version: $full_ver
Release: 1
License: GPL-2
Group: Applications/Sound
URL: http://qomp.sourceforge.net/
Source0: $package_name
BuildRequires: $builddeps
%{!?_without_freedesktop:BuildRequires: desktop-file-utils}

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-build

%description
Quick(Qt) Online Music Player

%prep
%setup

%build
%cmake -DCMAKE_INSTALL_PREFIX=${PREFIX}
%{__make} %{?_smp_mflags}

%install
[ "%{buildroot}" != "/"] && rm -rf %{buildroot}

%{__make} install DESTDIR="%{buildroot}"

mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/16x16/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/24x24/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/32x32/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/48x48/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/64x64/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/128x128/apps
mkdir -p %{buildroot}/usr/share/$progname/themes
mkdir -p %{buildroot}/usr/share/$progname/translations

if [ "%{_target_cpu}" = "x86_64" ] && [ -d "/usr/lib64" ]; then
  mkdir -p %{buildroot}/usr/lib64
else
  mkdir -p %{buildroot}/usr/lib
fi

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%files
%defattr(-, root, root, 0755)

%{_bindir}/$progname
%{_libdir}/lib$progname.so.$full_ver
%{_libdir}/$progname/plugins/
%{_datadir}/applications/$progname.desktop
%{_datadir}/icons/hicolor/16x16/apps/$progname.png
%{_datadir}/icons/hicolor/24x24/apps/$progname.png
%{_datadir}/icons/hicolor/32x32/apps/$progname.png
%{_datadir}/icons/hicolor/48x48/apps/$progname.png
%{_datadir}/icons/hicolor/64x64/apps/$progname.png
%{_datadir}/icons/hicolor/128x128/apps/$progname.png
%{_datadir}/$progname/translations
%{_datadir}/$progname/themes/themes.rcc
END
cp -f ${package_name} ${srcpath}
cd ${homedir}/rpmbuild/SPECS
rpmbuild -ba --clean --rmspec --rmsource ${progname}.spec
echo "Cleaning..."
rm -rf ${rpmbuild_dir}
