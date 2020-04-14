'use strict';

// Define paths
const path = require('path');
const PATHS = {
    app: path.join(__dirname, 'src'),
    build: path.join(__dirname, 'dist')
};

// A tool to merge config object
const merge = require('webpack-merge');
const plugins = require('./webpack.plugins');

// Common configuration for production and dev
const common = merge(
    {
        entry: {
            harmony_runtime: [
                path.join(PATHS.app, 'composer-common', 'index.js')/*,
                path.join(PATHS.app, 'composer-runtime', 'index.js')*/
                /*path.join(PATHS.app, 'log', 'node.js')*/
            ]
        },
        output: {
            path: path.join(PATHS.build),
            filename: '[name].js'/*,
            chunkFilename: '[chunkhash].js'*/
        },
        module: {
            rules: [{
                test: /\.(js|pegjs)$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ['es2015']
                    }
                }
            }]
        }
    },
    plugins.clean(PATHS.build)
);

// Detect the branch where npm is running on
var config = null;
console.log(process.env.npm_lifecycle_event);
switch (process.env.npm_lifecycle_event) {
    case 'product':
        config = merge(
            common,
            plugins.minify()
        );
        break;

    case 'build':
    default:
        config = merge(
            common/*,
            {
                devtool: 'source-map'
            }*/
        );
        break;
}
module.exports = config;
