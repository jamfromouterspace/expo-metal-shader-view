import { MutableRefObject, RefAttributes } from 'react';
import type { StyleProp, View, ViewStyle } from 'react-native';

export type OnErrorEventPayload = {
  error: string;
};

export type Uniforms =  {
  // iTime: number;
  iResolution: [number, number]; // equivalent to SIMD2<Float>
  varFloat1: number;
  varFloat2: number;
  varFloat3: number;
  varCumulativeFloat1: number;
  varCumulativeFloat2: number;
  varCumulativeFloat3: number;
  // varFloatArray: Float32Array; // should have 32 elements
  varInt1: number;
  varInt2: number;
  varInt3: number;
  varBool1: boolean;
  varBool2: boolean;
  varBool3: boolean;
}

export interface ExpoMetalShaderViewRef {
  updateUniforms: (newUniforms: Uniforms) => void;
}

export type ExpoMetalShaderViewProps = {
  shader: string;
  onError: (event: { nativeEvent: OnErrorEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
} & RefAttributes<ExpoMetalShaderViewRef>;
