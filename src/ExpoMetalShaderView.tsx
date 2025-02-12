import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoMetalShaderViewProps, ExpoMetalShaderViewRef } from './ExpoMetalShaderView.types';

const NativeView: React.ComponentType<ExpoMetalShaderViewProps> =
  requireNativeView('ExpoMetalShaderView');

const ExpoMetalShaderView = React.forwardRef<ExpoMetalShaderViewRef, ExpoMetalShaderViewProps>(
  (props, ref) => {
    return <NativeView {...props} ref={ref} />;
  }
);

export default ExpoMetalShaderView