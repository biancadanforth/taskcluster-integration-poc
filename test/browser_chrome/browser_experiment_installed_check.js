/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// (Modeled after Screenshots system add-on tests in browser/extensions/screenshots/test)

/* global ChromeUtils, AddonManager, add_task, ok, is */

ChromeUtils.defineModuleGetter(this, 'AddonManager',
  'resource://gre/modules/AddonManager.jsm');

const ADDON_NAME = 'taskcluster-integration-poc';
const ADDON_ID = `${ADDON_NAME}@mozilla.org`;

add_task(async () => {
  const addon = await AddonManager.getAddonByID(`${ADDON_ID}`);
  ok(!!addon, 'Addon exists');
  is(addon.name, `${ADDON_NAME}`, 'Addon has matching id');
});
