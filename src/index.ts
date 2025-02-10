// Reexport the native module. On web, it will be resolved to ExpoMetalShaderViewModule.web.ts
// and on native platforms to ExpoMetalShaderViewModule.ts
export { default } from './ExpoMetalShaderViewModule';
export { default as ExpoMetalShaderView } from './ExpoMetalShaderView';
export * from  './ExpoMetalShaderView.types';
