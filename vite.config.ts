import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    tailwindcss()
  ]
})
