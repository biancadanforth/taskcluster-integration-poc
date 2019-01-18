#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Clone the version-control-tools hg repo so that the push-to-try extension is
# installed in hg via hg's global config file, ~/.hgrc.
# This extension is required for pushing to the Try server; firefoxtree is recommended.

set -e

# This repo has the requisite extension `push-to-try` and the recommended extension firefoxtree
# Reference: https://wiki.mozilla.org/ReleaseEngineering/TryServer, Configuration section
echo ">>> Clone Mozilla Version Control Tools hg repo"
cd ~
hg clone https://hg.mozilla.org/hgcustom/version-control-tools/

# Let hg know where to find these extensions
echo ">>> Create .hgrc file to enable firefoxtree and push-to-try extensions"
if [ ! -f ~/.hgrc ]
then
   cat <<EOF > ~/.hgrc
[ui]
username = Bianca Danforth <bdanforth@mozilla.com>
[extensions]
firefoxtree = /root/version-control-tools/hgext/firefoxtree
push-to-try = /root/version-control-tools/hgext/push-to-try
EOF
fi
