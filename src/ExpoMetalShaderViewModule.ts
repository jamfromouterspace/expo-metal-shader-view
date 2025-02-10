import { NativeModule, requireNativeModule } from 'expo';

import { ExpoMetalShaderViewModuleEvents } from './ExpoMetalShaderView.types';

declare class ExpoMetalShaderViewModule extends NativeModule<ExpoMetalShaderViewModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoMetalShaderViewModule>('ExpoMetalShaderView');
