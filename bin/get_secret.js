/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// eslint-disable-next-line import/no-extraneous-dependencies
const taskcluster = require("taskcluster-client");
const fs = require("fs");

const SSHKEY_SECRET_NAME = process.env.SSHKEY_SECRET_NAME || "";
const IDENTITY_FILE = `${process.env.HOME}/.ssh/id_rsa_experiments_pusher`;

(async function main() {
  if (SSHKEY_SECRET_NAME) {
    const secrets = new taskcluster.Secrets({rootUrl: "http://taskcluster"});
    const sshKeySecret = await secrets.get(SSHKEY_SECRET_NAME);
    const sshKey = sshKeySecret.secret["ssh-key"] || null;
    if (sshKey) {
      fs.writeFile(IDENTITY_FILE, sshKey, "utf8", (err) => {
        if (err) console.log(err);
        // Try server rejects if identity file permissions are too open; restrict to read by owner only
        fs.chmod(IDENTITY_FILE, fs.constants.S_IRUSR, (err) => {
          if (err) console.log(err);
        });
      });
    }
  }
}());
