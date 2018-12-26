#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Clones Firefox, copies the XPI to a test directory and commits the change to Mercurial.

set -e

# TODO: Make env variable in .taskcluster.yml that gets passed to this script to specify
# which channel(s) to test in

# Repo URLs:
#   - Nightly: https://hg.mozilla.org/mozilla-central
#   - Beta: https://hg.mozilla.org/releases/mozilla-beta
#   - Release: https://hg.mozilla.org/releases/mozilla-release
echo ">>> clone Firefox"
# TODO: Investigate how to get a shallow clone of Firefox -- this full clone takes 3ish minutes alone.
hg clone https://hg.mozilla.org/mozilla-central

# Test dir(s) specified per bugs 1451159 and 1458571
echo ">>> copy XPI (or ZIP) to test dir"
cp /repo/web-ext-artifacts/* /repo/mozilla-central/testing/profiles/common/extensions/

# --artifact is not a recognized option for './mach build', so enable artifact builds via .mozconfig
echo ">>> create .mozconfig to enable artifact builds locally"
# TODO: For Beta and Release builds, add 'releases/mozilla-beta' or 'releases/mozilla-release'
# respectively to the list of CANDIDATE_TREES in ./python/mozbuild/mozbuild/artifacts.py

echo ">>> build Firefox"
# ./mach clobber
# ./mach build

# The diff does NOT need to be checked in to run tests locally
# Note: The extension is only installed with the testing profile (i.e. when running mochitests or talos
# tests); it is not installed with ./mach build or ./mach run separately.
echo ">>> verify with local mochitest that extension is installed"
# ./mach mochitest /path/to/test

# The diff needs to be checked in to run on the Try server
echo ">>> commit diff to hg"

# TODO: What would this look like? Try running a local ./mach test? Would need to build
# Firefox locally as well.
echo ">>> verify commit"
