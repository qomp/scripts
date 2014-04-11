
EAPI=5

inherit cmake-utils git-r3

IUSE="
	qtphonon
	gstreamer
	filesystemplugin
	urlplugin
	prostopleerplugin
	myzukaruplugin
	yandexmusicplugin
	lastfmplugin
	tunetofileplugin
	mprisplugin
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

REQUIRED_USE="filesystemplugin"

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

use filesystemplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};filesystemplugin"
use urlplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};urlplugin"
use prostopleerplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};prostopleerplugin"
use myzukaruplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};myzukaruplugin"
use yandexmusicplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};yandexmusicplugin"
use lastfmplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};lastfmplugin"
use tunetofileplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};tunetofileplugin"
use mprisplugin && PLUGINS_FLAGS="${PLUGINS_FLAGS};mprisplugin"

src_configure() {
	if [[ ! -z ${PLUGINS_FLAGS} ]] ; then
		mycmakeargs="${mycmakeargs}
			-DBUILD_PLUGINS='${PLUGINS_FLAGS}'"
	fi
	cmake-utils_src_configure
}

src_prepare() {
	if use qtphonon; then
		cd $${WORKDIR}/${P}
		#patch must be in files dir
		epatch ${PATCH1} || die "patching with ${PATCH1} failed"
	fi
}
