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
echo ">>> shallow clone Firefox"
hg clone --rev=5 https://hg.mozilla.org/mozilla-central

# Test dir(s) specified per bugs 1451159 and 1458571
echo ">>> copy XPI to test dir"

# --artifact is not a recognized option for './mach build', so enable artifact builds via .mozconfig
echo ">>> create .mozconfig to enable artifact builds locally"
# TODO: For Beta and Release builds, add 'releases/mozilla-beta' or 'releases/mozilla-release'
# respectively to the list of CANDIDATE_TREES in ./python/mozbuild/mozbuild/artifacts.py

# Note: The extension is only installed with the testing profile (i.e. when running mochitests or talos
# tests); it is not installed with ./mach build or ./mach run separately.
echo ">>> verify successful mochitest locally"
# ./mach mochitest /path/to/test

echo ">>> commit diff to hg"

# TODO: What would this look like? Try running a local ./mach test? Would need to build
# Firefox locally as well.
echo ">>> verify commit"
