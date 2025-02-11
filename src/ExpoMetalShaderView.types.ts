import type { StyleProp, ViewStyle } from 'react-native';

export type OnErrorEventPayload = {
  error: string;
};

export type ExpoMetalShaderViewModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
};

export type ChangeEventPayload = {
  value: string;
};

export type Uniforms = {
  iTime: number,
  iResolution: [number, number],
  var1: number,
  var2: number,
  var3: number,
  var4: number,
  var5: number,
  var6: boolean
}

export type ExpoMetalShaderViewProps = {
  shader: string;
  uniforms: Uniforms;
  isPaused: boolean;
  onError: (event: { nativeEvent: OnErrorEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
};
