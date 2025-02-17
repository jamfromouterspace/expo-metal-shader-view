import { MutableRefObject, RefAttributes } from 'react';
import type { StyleProp, View, ViewStyle } from 'react-native';

export type ErrorEventPayload = {
  error: string;
};

export type ExpoMetalShaderViewModuleEvents = {
  onError: (params: ErrorEventPayload) => void;
};
 
export type Uniforms =  {
  iResolution: [number, number]; // equivalent to SIMD2<Float>
  varFloat1: number;
  varFloat2: number;
  varFloat3: number;
  varCumulativeFloat1: number;
  varCumulativeFloat2: number;
  varCumulativeFloat3: number;
  varInt1: number;
  varInt2: number;
  varInt3: number;
  varBool1: boolean;
  varBool2: boolean;
  varBool3: boolean;

  color1R: number;
  color1G: number;
  color1B: number;

  color2R: number;
  color2G: number;
  color2B: number;

  color3R: number;
  color3G: number;
  color3B: number;

  intensity1: number;
  intensity2: number;
  intensity3: number;

  cumulativeBass: number;
  bass: number;

  /** 64 element array */
  spectrum: number[];
}

export interface ExpoMetalShaderViewRef {
  updateUniforms: (newUniforms: Partial<Uniforms>) => void;
}

export type ExpoMetalShaderViewProps = {
  shader: string;
  onError: (event: { nativeEvent: ErrorEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
} & RefAttributes<ExpoMetalShaderViewRef>;
