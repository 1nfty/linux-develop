'use strict';

const webpack = require('webpack');

exports.minify = function () {
    return {
        plugins: [
            new webpack.optimize.UglifyJsPlugin({
                //Don't beautify output(enable for neater output)
                beautify: false,
                //Eliminate comments
                comments: false,
                compress: {
                    warnings: false,
                    //Drop `console` statements
                    drop_console: true
                }
            })
        ]
    };
}

//Clean a specific folder
exports.clean = function (path) {
    const CleanWebpackPlugin = require('clean-webpack-plugin');

    return {
        plugins: [
            new CleanWebpackPlugin([path], {
                //With out `root` CleanWebpackPlugin won't point to our
                //project and will fail to work.
                root: process.cwd()
            })
        ]
    };
}

exports.extractCommon = function (name) {
    return {
        plugins: [
            new webpack.optimize.CommonsChunkPlugin(name)
        ]
    };
}
