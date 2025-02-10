import { registerWebModule, NativeModule } from 'expo';

import { ExpoMetalShaderViewModuleEvents } from './ExpoMetalShaderView.types';

class ExpoMetalShaderViewModule extends NativeModule<ExpoMetalShaderViewModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(ExpoMetalShaderViewModule);
