'use strict';

const path = require('node:path');
const url = require('node:url');

const root = process.env.CUCUMBER_LS_ROOT;
if (!root) {
  throw new Error('CUCUMBER_LS_ROOT is not set');
}

const languageServerRoot = path.join(root, 'node_modules', '@cucumber', 'language-server');
const languageServiceRoot = path.join(languageServerRoot, 'node_modules', '@cucumber', 'language-service');

const { startStandaloneServer } = require(path.join(languageServerRoot, 'dist', 'cjs', 'src', 'wasm', 'startStandaloneServer.js'));
const { NodeFiles } = require(path.join(languageServerRoot, 'dist', 'cjs', 'src', 'node', 'NodeFiles.js'));
const { CucumberLanguageServer } = require(path.join(languageServerRoot, 'dist', 'cjs', 'src', 'CucumberLanguageServer.js'));
const fastGlob = require(path.join(languageServerRoot, 'node_modules', 'fast-glob'));

function patchDefineStepQueries() {
  const { tsxLanguage } = require(path.join(languageServiceRoot, 'dist', 'cjs', 'src', 'language', 'tsxLanguage.js'));
  const { javascriptLanguage } = require(path.join(languageServiceRoot, 'dist', 'cjs', 'src', 'language', 'javascriptLanguage.js'));

  const patch = (language) => {
    if (!language || !Array.isArray(language.defineStepDefinitionQueries)) {
      return;
    }

    language.defineStepDefinitionQueries = language.defineStepDefinitionQueries.map((query) => {
      if (!query.includes('Given|When|Then') || query.includes('defineStep')) {
        return query;
      }
      return query.replace('Given|When|Then', 'Given|When|Then|defineStep');
    });
  };

  patch(tsxLanguage);
  patch(javascriptLanguage);
}

function patchSettingsFallback() {
  const originalGetSettings = CucumberLanguageServer.prototype.getSettings;

  CucumberLanguageServer.prototype.getSettings = async function patchedGetSettings() {
    const settings = await originalGetSettings.call(this);

    const extraFeatures = [
      '**/src/test/**/*.feature',
      '**/features/**/*.feature',
      '**/tests/**/*.feature',
      '**/*specs*/**/*.feature',
    ];

    const extraGlue = [
      '**/src/test/**/*.java',
      '**/features/**/*.ts',
      '**/features/**/*.tsx',
      '**/features/**/*.js',
      '**/features/**/*.jsx',
      '**/features/**/*.php',
      '**/features/**/*.py',
      '**/tests/**/*.py',
      '**/tests/**/*.rs',
      '**/features/**/*.rs',
      '**/features/**/*.rb',
      '**/*specs*/**/*.cs',
      '**/features/**/*_test.go',
      '**/tests/features/**/*.js',
      '**/tests/features/**/*.ts',
      '**/tests/features/**/*.tsx',
      '**/step_definitions/**/*.java',
      '**/step_definitions/**/*.ts',
      '**/step_definitions/**/*.tsx',
      '**/step_definitions/**/*.js',
      '**/step_definitions/**/*.jsx',
      '**/step_definitions/**/*.php',
      '**/step_definitions/**/*.py',
      '**/step_definitions/**/*.rs',
      '**/step_definitions/**/*.rb',
      '**/step_definitions/**/*.cs',
      '**/step_definitions/**/*_test.go',
      '**/steps/**/*.java',
      '**/steps/**/*.ts',
      '**/steps/**/*.tsx',
      '**/steps/**/*.js',
      '**/steps/**/*.jsx',
      '**/steps/**/*.php',
      '**/steps/**/*.py',
      '**/steps/**/*.rs',
      '**/steps/**/*.rb',
      '**/steps/**/*.cs',
      '**/steps/**/*_test.go',
    ];

    return {
      ...settings,
      features: Array.from(new Set([...(settings.features || []), ...extraFeatures])),
      glue: Array.from(new Set([...(settings.glue || []), ...extraGlue])),
    };
  };
}

class PatchedNodeFiles extends NodeFiles {
  async findUris(glob) {
    const cwd = url.fileURLToPath(this.rootUri);
    const paths = await fastGlob(glob, { cwd, caseSensitiveMatch: false, onlyFiles: true, absolute: true });
    return paths.map((filePath) => url.pathToFileURL(filePath).href);
  }
}

patchDefineStepQueries();
patchSettingsFallback();

const wasmBasePath = path.join(languageServiceRoot, 'dist');
startStandaloneServer(wasmBasePath, (rootUri) => new PatchedNodeFiles(rootUri));
