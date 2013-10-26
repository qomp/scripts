# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit qt4-r2 git-2

IUSE="
	qtphonon
	gstreamer
	vlc
"

DEPEND="
	dev-qt/qtgui
	dev-qt/qtwebkit
	dev-libs/openssl
	!qtphonon? ( media-libs/phonon )
	qtphonon? ( dev-qt/qtphonon )
	gstreamer? ( media-libs/phonon-gstreamer )
	vlc? ( media-libs/phonon-vlc )
"

REQUIRED_USE="qtphonon? ( !gstreamer )"

REQUIRED_USE="qtphonon? ( !vlc )"

REQUIRED_USE="|| ( qtphonon gstreamer vlc )"

RDEPEND="
	${DEPEND}
	dev-qt/qtcore
	dev-qt/qtdbus
"

DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="https://code.google.com/p/qomp/"
EGIT_REPO_URI="https://thetvg@code.google.com/p/qomp/"
EGIT_HAS_SUBMODULES="y"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

PATCH1="${FILESDIR}/qtphonon-patch.patch"

qt4-r2_src_configure() {
	eqmake4 ${EGIT_SOURCEDIR}/qomp.pro PREFIX=/usr
}

qt4-r2_src_prepare() {
	if use qtphonon; then
		cd ${EGIT_SOURCEDIR}
		#patch must be in files dir
		epatch ${PATCH1} || die "patching with ${PATCH1} failed"
	fi
}
