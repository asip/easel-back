import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  server: {
    port: 3036,
    hmr: {
      protocol: 'ws',
    }
  },
  plugins: [
    RubyPlugin(),
    tailwindcss()
  ]
})
