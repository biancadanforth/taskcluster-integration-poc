#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Clones Firefox, copies the XPI and any custom tests to testing directories
# and commits the change to Mercurial.

set -e

# Note: If clone fails with error: `abort: unexpected response from remote
# server: empty string.`, that clonebundle may be corrupted. Try another URL
# to confirm and contact #vcs in IRC.
echo ">>> Clone Firefox"
hg clone https://hg.mozilla.org/mozilla-central

# Per bugs 1451159/1458571, when copied here, the extension will be installed
# with the testing profile.
echo ">>> Copy XPI (or ZIP) to test dir"
cp /repo/web-ext-artifacts/* /repo/mozilla-central/testing/profiles/common/extensions/

# Run custom mochitest on Docker image before pushing to Try (See bug 1517083)
echo ">>> Create .mozconfig to enable artifact builds locally"
if [ ! -f /repo/mozilla-central/.mozconfig ]
then
  cat <<EOF > /repo/mozilla-central/.mozconfig
# Automatically download and use compiled C++ components:
ac_add_options --enable-artifact-builds
EOF
fi
echo ">>> Copy test files over to Firefox"
cp -r /repo/test/* /repo/mozilla-central/testing/extensions/
echo ">>> Build Firefox"
cd mozilla-central
./mach build
echo ">>> Verify with custom local mochitest that extension is installed"
./mach test testing/extensions

# The diff needs to be checked in to run on the Try server
echo ">>> Commit diff to hg"
hg add .
hg commit -m "Temporary commit to run extension on the Try server"
