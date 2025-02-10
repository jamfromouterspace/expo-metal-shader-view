import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoMetalShaderViewProps } from './ExpoMetalShaderView.types';

const NativeView: React.ComponentType<ExpoMetalShaderViewProps> =
  requireNativeView('ExpoMetalShaderView');

export default function ExpoMetalShaderView(props: ExpoMetalShaderViewProps) {
  return <NativeView {...props} />;
}
