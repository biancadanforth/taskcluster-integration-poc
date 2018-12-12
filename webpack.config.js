/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* eslint-env node */
/* eslint-disable import/no-extraneous-dependencies */

const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const GenerateJsonPlugin = require('generate-json-webpack-plugin');

const packageData = require('./package.json');
const manifestTemplate = require('./src/manifest.json');

const ROOT_DIR = path.resolve(__dirname, '.');
const BUILD_DIR = path.resolve(ROOT_DIR, 'build');

module.exports = {
  mode: 'development',
  devtool: 'inline-source-map',
  target: 'web',
  context: ROOT_DIR,
  entry: {
    background: './src/background',
    content: './src/content-script',
  },
  output: {
    path: BUILD_DIR,
    filename: '[name].bundle.js',
  },
  node: { fs: 'empty' },
  plugins: [
    new CopyWebpackPlugin([
      // Static files
      {from: '**/*.png'},
    ], {context: 'src/'}),

    // Process and emit manifest.json, replacing any values that start with $
    // with the corresponding key from package.json.
    new GenerateJsonPlugin('manifest.json', manifestTemplate, (key, value) => {
      if (typeof value === 'string' && value.startsWith('$')) {
        const parts = value.slice(1).split('.');
        let object = packageData;
        while (parts.length > 0) {
          object = object[parts.pop()];
        }
        return object;
      }
      return value;
    }),
  ],
};
