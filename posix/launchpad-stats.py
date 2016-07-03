#!/usr/bin/python2

# Usage python launchpad-stats.py DIST (Ubuntu version eg maverick) ARCH (ubuntu arch eg i386 or amd64)

import sys
from launchpadlib.launchpad import Launchpad

PPAOWNER = "qomp"
PPA = "ppa"
desired_dist_and_arch = 'https://api.launchpad.net/devel/ubuntu/' + sys.argv[1] + '/' + sys.argv[2]

cachedir = "~/.launchpadlib/cache/"
lp_ = Launchpad.login_anonymously('ppastats', 'production', cachedir)
owner = lp_.people[PPAOWNER]
archive = owner.getPPAByName(name=PPA)

for individualarchive in archive.getPublishedBinaries(status='Published', distro_arch_series=desired_dist_and_arch):
    x = individualarchive.getDownloadCount()
    if x > 0:
        print individualarchive.binary_package_name + "\t" + individualarchive.binary_package_version + "\t" + str(individualarchive.getDownloadCount())
    elif x < 1:
        print '0'

