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
svndir=${builddir}/${progname}
if [ ! -d ${homedir}/rpmbuild ]
then
	cd ${homedir}
	mkdir -p ${homedir}/rpmbuild/SOURCES
	mkdir -p ${homedir}/rpmbuild/SPECS
fi
srcpath=${homedir}/rpmbuild/SOURCES
cd $homedir
if [ ! -d "${svndir}" ]
then
	git clone https://github.com/qomp/qomp.git ${svndir}
	cd ${svndir}
	git submodule init
	git submodule update
else
	cd ${svndir}
	git pull
	git submodule update
	git pull
fi
cd ${homedir}
defines=${svndir}/libqomp/src/defines.h
ver_s=`grep APPLICATION_VERSION $defines`
ver=`echo $ver_s | cut -d '"' -f 2 | sed "s/\s/_/"`
package_name=${progname}-${ver}.tar.gz
tmpbuilddir=${rpmbuild_dir}/${progname}-${ver}
if [ -d "${tmpbuilddir}" ]
then
	rm -r -f ${tmpbuilddir}
fi
mkdir -p ${tmpbuilddir}
cp -rf ${svndir}/* ${tmpbuilddir}/
cd ${rpmbuild_dir}
tar -pczf ${package_name} ${progname}-${ver}
cat <<END >${homedir}/rpmbuild/SPECS/${progname}.spec
Summary: Quick(Qt) Online Music Player
Name: $progname
Version: $ver
Release: 1
License: GPL-2
Group: Applications/Sound
URL: https://code.google.com/p/qomp/
Source0: $package_name
BuildRequires: gcc-c++, zlib-devel, phonon-devel
%{!?_without_freedesktop:BuildRequires: desktop-file-utils}

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-build

%description
Quick(Qt) Online Music Player

%prep
%setup

%build
cmake -DCMAKE_INSTALL_PREFIX=%{buildroot}/usr .
%{__make} %{?_smp_mflags}

%install
[ "%{buildroot}" != "/"] && rm -rf %{buildroot}

%{__make} install INSTALL_ROOT="%{buildroot}"

mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/16x16/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/24x24/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/32x32/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/48x48/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/64x64/apps
mkdir -p %{buildroot}/usr/share/icons/hicolor/128x128/apps
mkdir -p %{buildroot}/usr/share/qomp/plugins
mkdir -p %{buildroot}/usr/share/qomp/translations

if [ "%{_target_cpu}" = "x86_64" ] && [ -d "/usr/lib64" ]; then
  mkdir -p %{buildroot}/usr/lib64
else
  mkdir -p %{buildroot}/usr/lib
fi

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%files
%defattr(-, root, root, 0755)

%{_bindir}/qomp
%{_libdir}
%{_datadir}/applications/
%{_datadir}/icons/hicolor/16x16/apps/
%{_datadir}/icons/hicolor/24x24/apps/
%{_datadir}/icons/hicolor/32x32/apps/
%{_datadir}/icons/hicolor/48x48/apps/
%{_datadir}/icons/hicolor/64x64/apps/
%{_datadir}/icons/hicolor/128x128/apps/
%{_datadir}/qomp/translations
%{_datadir}/qomp/plugins
END
cp -f ${package_name} ${srcpath}
cd ${homedir}/rpmbuild/SPECS
rpmbuild -ba --clean --rmspec --rmsource ${progname}.spec
echo "Cleaning..."
rm -rf ${rpmbuild_dir}
