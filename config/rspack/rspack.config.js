import { fileURLToPath } from 'node:url'
import path from 'node:path'
import { defineConfig } from '@rspack/cli'
import rspack from '@rspack/core'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// eslint-disable-next-line no-undef
const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production'
export default defineConfig({
  mode,
  resolve: {
    // alias: {
    //  vue$: 'vue/dist/vue.esm-bundler.js',
    // },
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
    new rspack.optimize.LimitChunkCountPlugin({
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
        exclude: [/node_modules/],
        loader: 'builtin:swc-loader',
        options: {
          jsc: {
            parser: {
              syntax: 'typescript',
            },
          },
        },
        type: 'javascript/auto'
      }
    ]
  }
})
