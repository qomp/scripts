# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit qt4-r2 git-2
DEPEND="
	dev-qt/qtgui
	dev-qt/qtwebkit
	dev-libs/openssl
"
IUSE="
	qtphonon
	gstreamer
	vlc
"

REQUIRED_USE="qtphonon? ( !gstreamer )"

REQUIRED_USE="qtphonon? ( !vlc )"

RDEPEND="
	${DEPEND}
	dev-qt/qtcore
	dev-qt/qtdbus
"
DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="https://code.google.com/p/qomp/"
EGIT_REPO_URI="https://thetvg@code.google.com/p/qomp/"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

PATCH1="${FILESDIR}/qtphonon-patch.patch"

if use gstreamer; then
  DEPEND="${DEPEND} media-libs/phonon media-libs/phonon-gstreamer"
fi
if use vlc; then
  DEPEND="${DEPEND} media-libs/phonon media-libs/phonon-vlc"
 fi

if use qtphonon; then
	DEPEND="${DEPEND} dev-qt/qtphonon"
fi

src_prepare() {
#change default prefix
	cd ${EGIT_SOURCEDIR}
	git submodule init
	git submodule update
	qmake PREFIX=/usr qomp.pro
	if use qtphonon; then
		cd ${EGIT_SOURCEDIR}
		#patch must be in files dir
		epatch ${PATCH1}
	fi
}
