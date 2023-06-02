// eslint-disable-next-line no-undef
const path    = require('path')
// eslint-disable-next-line no-undef
const webpack = require('webpack')
// eslint-disable-next-line no-undef
const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

// eslint-disable-next-line no-undef
module.exports = {
  mode,
  resolve: {
    alias: {
      vue$: 'vue/dist/vue.esm-bundler.js',
    },
    extensions: ['.js', '.ts']
  },
  entry: {
    application: './app/javascript/application.js'
  },
  output: {
    filename: '[name].js',
    sourceMapFilename: '[name].js.map',
    // eslint-disable-next-line no-undef
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ],
  optimization: {
    chunkIds: 'named'
  },
  module: {
    rules: [
      {
        test: /\.[jt]s$/,
        loader: 'esbuild-loader',
        options: {
          target: 'es2015'  // Syntax to compile to (see options below for possible values)
        }
      }
    ]
  }
}
