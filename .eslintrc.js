module.exports = {
  env: {
    es2022: true
  },
  extends: [
    "eslint:recommended",
    "prettier"
  ],
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: "module"
  },
  rules: {
    // 共通のルールを設定
    semi: ["error", "never"],
    quotes: ["error", "single"],
    indent: ["error", 2]
  },
  overrides: [
    {
      files: ["**/*.ts"],
      extends: [
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:@typescript-eslint/recommended"
      ],
      parser: "@typescript-eslint/parser",
      parserOptions: {
        sourceType: "module",
        project: "./tsconfig.json"
      },
      plugins: [
        "@typescript-eslint"
      ],
      rules: {
        "@typescript-eslint/no-explicit-any": 1,
        "@typescript-eslint/no-non-null-assertion": 1
      }
    }
  ],
  ignorePatterns: [
    "./app/assets/builds/**/*" // Ignore built files.
  ],
  root: true
}
