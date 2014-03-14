# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils git-r3

IUSE="
	qtphonon
	gstreamer
	vlc
"

DEPEND="
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtgui
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
	dev-qt/qtopengl
"

DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="https://code.google.com/p/qomp/"
EGIT_REPO_URI="https://code.google.com/p/qomp/"
EGIT_MIN_CLONE_TYPE="shallow"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

PATCH1="${FILESDIR}/qtphonon-patch.patch"

src_prepare() {
	if use qtphonon; then
		cd $${WORKDIR}/${P}
		#patch must be in files dir
		epatch ${PATCH1} || die "patching with ${PATCH1} failed"
	fi
}
