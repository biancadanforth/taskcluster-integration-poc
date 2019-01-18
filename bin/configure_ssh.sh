#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Makes a .ssh dir if one does not exist and adds a $HOME/.ssh/config file.
# The secret fetched from Taskcluster is a private SSH key. It will be
# stored in $HOME/.ssh/id_rsa_experiments_pusher (see ./bin/get_secret.js)
# and that file is pointed at by the $HOME/.ssh/config file. Once we have
# this key and SSH config set up, we can push to the Try server!

set -e

echo ">>> Make the $HOME/.ssh dir if it doesn't exist"
cd ~
if [ ! -d .ssh ]
then
  mkdir .ssh
fi

echo ">>> Set up SSH config with Experiments Pusher user"
if [ ! -f ~/.ssh/config ]
then
  cat <<EOF > ~/.ssh/config
Host hg.mozilla.org
  User experiments-pusher@mozilla.com
  # for experiments try server pushing
  IdentityFile ~/.ssh/id_rsa_experiments_pusher
EOF
fi

# Without this, the first time I connect to this server, it will prompt me
# to ask if I am sure I want to connect, and the task will hang and timeout.
echo ">>> Put hg.mozilla.org server on the list of known hosts"
if [ ! -f ~/.ssh/known_hosts ]
then
   touch ~/.ssh/known_hosts
   ssh-keyscan -t rsa -H hg.mozilla.org >> ~/.ssh/known_hosts
fi
