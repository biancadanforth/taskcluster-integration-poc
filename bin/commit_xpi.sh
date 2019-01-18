#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Clones Firefox, copies the XPI to a test directory and commits the change to Mercurial.

set -e

# Note: If clone fails with error: `abort: unexpected response from remote server: empty string.`,
# that clonebundle may be corrupted. Try another URL to confirm and talk to sheehan in #vcs in IRC.
echo ">>> Clone Firefox"
hg clone https://hg.mozilla.org/mozilla-central

# Per bugs 1451159/1458571, when copied here, the extension will be installed with the testing profile.
echo ">>> Copy XPI (or ZIP) to test dir"
cp /repo/web-ext-artifacts/* /repo/mozilla-central/testing/profiles/common/extensions/

# TODO - depends on Bug 1517083, else must edit an existing moz.build file programmatically ~
# echo ">>> Copy over .mozconfig to enable artifact builds locally"
# echo ">>> Copy test files over to Firefox"
# echo ">>> Build Firefox"
# echo ">>> Verify with custom local mochitest that extension is installed"

# The diff needs to be checked in to run on the Try server
echo ">>> Commit diff to hg"
cd mozilla-central
hg add .
hg commit -m "Temporary commit to run extension on the Try server"
