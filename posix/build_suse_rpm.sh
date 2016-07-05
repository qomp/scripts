#!/bin/bash
progname=qomp
PREFIX=/usr
homedir=$HOME
builddir=${homedir}/build
rpmbuild_dir=${builddir}/build_${progname}
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
ver=$(grep -e '[^_]APPLICATION_VERSION' $defines | cut -d '"' -f 2 | sed "s/\s/_/")
package_name=${progname}-${ver}.tar.gz
tmpbuilddir=${rpmbuild_dir}/${progname}-${ver}
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
tar -pczf ${package_name} ${progname}-${ver}
cat <<END >${homedir}/rpmbuild/SPECS/${progname}.spec
Summary: Quick(Qt) Online Music Player
Name: $progname
Version: $ver
Release: 1
License: GPL-2
Group: Applications/Sound
URL: http://qomp.sourceforge.net/
Source0: $package_name
BuildRequires: gcc-c++, zlib-devel, cmake, libcue-devel, libtag-deve, libqt5-qttools-devel, libqt5-qtbase-devel
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

cd build

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
%{_libdir}
%{_datadir}/applications/
%{_datadir}/icons/hicolor/16x16/apps/
%{_datadir}/icons/hicolor/24x24/apps/
%{_datadir}/icons/hicolor/32x32/apps/
%{_datadir}/icons/hicolor/48x48/apps/
%{_datadir}/icons/hicolor/64x64/apps/
%{_datadir}/icons/hicolor/128x128/apps/
%{_datadir}/$progname/translations
%{_datadir}/$progname/themes
END
cp -f ${package_name} ${srcpath}
cd ${homedir}/rpmbuild/SPECS
rpmbuild -ba --clean --rmspec --rmsource ${progname}.spec
echo "Cleaning..."
rm -rf ${rpmbuild_dir}
