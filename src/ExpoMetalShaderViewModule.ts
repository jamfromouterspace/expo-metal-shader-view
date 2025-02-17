import { NativeModule, requireNativeModule } from 'expo';

import { ExpoMetalShaderViewModuleEvents } from './ExpoMetalShaderView.types';

declare class ExpoMetalShaderViewModule extends NativeModule<ExpoMetalShaderViewModuleEvents> {}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoMetalShaderViewModule>('ExpoMetalShaderView');
