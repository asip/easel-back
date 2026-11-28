import { defineConfig } from 'eslint/config'

import js from '@eslint/js'
import tseslint from 'typescript-eslint'

export default defineConfig([
  {
    ignores: [
      './app/assets/builds/**/*', // Ignore built files.
    ],
  },
  {
    files: ['**/*.{js,ts}'],
    extends: [js.configs.recommended, tseslint.configs.recommended],
  },
])
