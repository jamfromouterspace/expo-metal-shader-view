import * as React from 'react';

import { ExpoMetalShaderViewProps } from './ExpoMetalShaderView.types';

export default function ExpoMetalShaderView(props: ExpoMetalShaderViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
