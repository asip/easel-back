import eslintConfigPrettier from 'eslint-config-prettier';
import js from '@eslint/js';
import typescriptESLintParser from '@typescript-eslint/parser'
import typescriptESLint from '@typescript-eslint/eslint-plugin'

export default [
  {
    ignores: [
      './app/assets/builds/**/*' // Ignore built files.
    ]
  },
  js.configs.recommended,
  eslintConfigPrettier,
  {
    languageOptions: {
      globals: {
        es2022: true
      }
    },
    rules: {
      // 共通のルールを設定
      semi: ['error', 'never'],
      quotes: ['error', 'single'],
      indent: ['error', 2]
    }
  },
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module'
    },
  },
  {
    files: ['**/*.ts'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      parser: typescriptESLintParser,
      parserOptions: {
        project: './tsconfig.json'
      }
    },
    plugins: {
      '@typescript-eslint': typescriptESLint
    },
    rules: {
      ...typescriptESLint.configs.recommended.rules,
      ...typescriptESLint.configs['eslint-recommended'].rules,
      ...typescriptESLint.configs['recommended-type-checked'].rules,
      ...typescriptESLint.configs.strict.rules,
      ...typescriptESLint.configs['strict-type-checked'].rules,
      ...typescriptESLint.configs.stylistic.rules,
      '@typescript-eslint/no-explicit-any': 0,
      '@typescript-eslint/no-non-null-assertion': 0
    }
  }
]
