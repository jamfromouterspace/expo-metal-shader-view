import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoMetalShaderViewProps } from './ExpoMetalShaderView.types';

const NativeView: React.ComponentType<ExpoMetalShaderViewProps> =
  requireNativeView('ExpoMetalShaderView');

export default function ExpoMetalShaderView(props: ExpoMetalShaderViewProps) {
  const uniforms = {
    iTime: props.uniforms.iTime,
    iResolutionX: props.uniforms.iResolution[0],
    iResolutionY: props.uniforms.iResolution[1],
    var1: props.uniforms.var1,
    var2: props.uniforms.var2,
    var3: props.uniforms.var3,
    var4: props.uniforms.var4,
    var5: props.uniforms.var5,
    var6: props.uniforms.var6,
  }
  return <NativeView {...props} uniforms={uniforms as any} />;
}
