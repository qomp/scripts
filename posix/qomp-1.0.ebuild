# Copyright 2013-2017 Qomp team
# Distributed under the terms of the GNU General Public License v3

EAPI=5

inherit cmake-utils

IUSE="
	qtphonon
	gstreamer
	+filesystemplugin
	urlplugin
	prostopleerplugin
	myzukaruplugin
	notificationsplugin
	yandexmusicplugin
	lastfmplugin
	tunetofileplugin
	mprisplugin
	vlc
	qt4
	qt5
"

DEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		yandexmusicplugin? ( dev-libs/qjson )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
		dev-qt/qtxml:5
	)
	dev-libs/openssl
	!qt5? (
		!qtphonon? ( media-libs/phonon )
	)
	qtphonon? ( dev-qt/qtphonon )
	gstreamer? ( media-libs/phonon-gstreamer )
	vlc? ( media-libs/phonon-vlc )
	media-libs/taglib
"

REQUIRED_USE="^^ ( qt4  qt5 )"
REQUIRED_USE="qt4? ( ^^ ( qtphonon || ( gstreamer vlc ) ) )"
REQUIRED_USE="qt5? ( !gstreamer !vlc !qtphonon )"
REQUIRED_USE="filesystemplugin"

RDEPEND="
	${DEPEND}
	qt4? ( dev-qt/qtopengl:4 )
	qt5? ( dev-qt/qtopengl:5 )
"

DESCRIPTION="Quick(Qt) Online Music Player - one player for different online music hostings"
HOMEPAGE="http://sourceforge.net/projects/qomp/"
SRC_URI="https://sourceforge.net/projects/qomp/files/1.0/dev/${PN}_${PV}-1.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

src_configure() {
	if use qtphonon; then
		#cd $${WORKDIR}/${P}
#https://raw.githubusercontent.com/qomp/scripts/master/posix/qtphonon-patch.patch
		epatch ${FILESDIR}/qtphonon-patch.patch
	fi
	use filesystemplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};filesystemplugin"
	use urlplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};urlplugin"
	use prostopleerplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};prostopleerplugin"
	use myzukaruplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};myzukaruplugin"
	use notificationsplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};notificationsplugin"
	use yandexmusicplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};yandexmusicplugin"
	use lastfmplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};lastfmplugin"
	use tunetofileplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};tunetofileplugin"
	use mprisplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};mprisplugin"
	local mycmakeargs=(
		$(cmake-utils_use_use qt5 QT5)
		$(echo -DBUILD_PLUGINS=${PLUGINS_FLAGS})
	)
	cmake-utils_src_configure
}
