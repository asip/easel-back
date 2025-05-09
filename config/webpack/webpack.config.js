import { fileURLToPath } from 'node:url'
import path from 'node:path'
import webpack from 'webpack'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// eslint-disable-next-line no-undef
const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production'

export default {
  mode,
  resolve: {
    // alias: {
    //  vue$: 'vue/dist/vue.esm-bundler.js',
    // },
    extensions: ['.js', '.ts']
  },
  entry: {
    application: './app/javascript/application.js',
    rails_admin: './app/javascript/rails_admin.js'
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
          target: 'es2022'  // Syntax to compile to (see options below for possible values)
        }
      }
    ]
  }
}
