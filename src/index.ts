// import {
//   NativeModulesProxy,
//   EventEmitter,
//   Subscription,
// } from "expo";
export * from  './ExpoMetalShaderView.types';

// Import the native module. On web, it will be resolved to ExpoAudioFFT.web.ts
// and on native platforms to ExpoAudioFFT.ts
import ExpoMetalShaderViewModule from "./ExpoMetalShaderViewModule";
import ExpoMetalShaderView from "./ExpoMetalShaderView";
import {
  ChangeEventPayload,
  ExpoAudioFFTViewProps,
} from "./ExpoAudioFFT.types";
import { EventEmitter } from 'expo';

// Get the native constant value.
export const PI = ExpoMetalShaderViewModule.PI;

export function hello(): string {
  return ExpoMetalShaderViewModule.hello();
}

export async function init(enableFFT = true): Promise<string> {
  return ExpoMetalShaderViewModule.init(enableFFT);
}

export async function load(localUri: string): Promise<string> {
  return ExpoMetalShaderViewModule.load(localUri);
}

export async function play(): Promise<string> {
  return ExpoMetalShaderViewModule.play();
}

export async function pause(): Promise<string> {
  return ExpoMetalShaderViewModule.pause();
}

export async function stop(): Promise<string> {
  return ExpoMetalShaderViewModule.pause();
}

export async function seek(toSeconds: number): Promise<string> {
  return ExpoMetalShaderViewModule.seek(toSeconds);
}

export function currentTime(): number {
  return ExpoMetalShaderViewModule.currentTime();
}

export type AudioMetadata = {
  duration: number;
  numChannels: number;
  sampleRate: number;
  totalSamples: number;
};

export function getMetadata(localUri: string): Promise<AudioMetadata> {
  return ExpoMetalShaderViewModule.getMetadata(localUri);
}

export function setBandingOptions(
  numBands: number,
  bandingMethod:
    | "logarithmic"
    | "linear"
    | "avg"
    | "min"
    | "max" = "logarithmic"
): Promise<void> {
  return ExpoMetalShaderViewModule.setBandingOptions(numBands, bandingMethod);
}

export async function getWaveformData(
  localUri: string,
  sampleCount: number
): Promise<number[]> {
  return await ExpoMetalShaderViewModule.getWaveformData(localUri, sampleCount);
}

const emitter = new EventEmitter(
  ExpoMetalShaderViewModule
  //  ?? NativeModulesProxy.ExpoAudioFFT
);

export type AudioBufferEvent = {
  rawMagnitudes: number[];
  bandMagnitudes: number[];
  bandFrequencies: number[];
  loudness: number;
  currentTime: number;
};

export function addAudioBufferListener(
  listener: (event: AudioBufferEvent) => void
) {
  // @ts-ignore
  return emitter.addListener("onAudioBuffer", listener);
}

export function addProgressListener(
  listener: (event: { currentTime: number }) => void
) {
  // @ts-ignore
  return emitter.addListener("onProgress", listener);
}

export { ExpoMetalShaderView, ExpoAudioFFTViewProps, ChangeEventPayload };
