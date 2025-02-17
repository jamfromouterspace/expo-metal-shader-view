import { useEvent } from 'expo';
import { ExpoMetalShaderView, ExpoMetalShaderViewRef, Uniforms } from 'expo-metal-shader-view';
import ExpoMetalShaderViewModule from 'expo-metal-shader-view/ExpoMetalShaderViewModule';
import { useEffect, useMemo, useRef } from 'react';
import { Button, Dimensions, SafeAreaView, ScrollView, Text, View } from 'react-native';
import Animated from "react-native-reanimated"
const windowWidth = Dimensions.get("window").width
const windowHeight = Dimensions.get("window").height

export default function App() {
  const shader = useMemo(() => {
    return `
      fragment float4 mainImage(FragmentIn input [[stage_in]],
                               constant Uniforms& uniforms,
                               constant uint2& viewSize) {
        return float4(uniforms.color1R, 0.0, 0.0, 1.0);
      }
    `
  }, [])

  const shaderRef = useRef<ExpoMetalShaderViewRef>(null)

  useEffect(() => {
    shaderRef.current?.updateUniforms({ color1R: 0.1, color1G: 0.6, color1B: 0.8 })
  }, [])

  return (
    <SafeAreaView style={styles.container}>
      <ExpoMetalShaderView
        ref={shaderRef}
        style={{
          flex: 1,
          height: 200,
          width: "100%"
        }}
        shader={shader}
        onError={({ nativeEvent: { error } }) => console.log(`Error: ${error}`)}
      />
    </SafeAreaView>
  );
}

function Group(props: { name: string; children: React.ReactNode }) {
  return (
    <View style={styles.group}>
      <Text style={styles.groupHeader}>{props.name}</Text>
      {props.children}
    </View>
  );
}

const styles = {
  header: {
    fontSize: 30,
    margin: 20,
  },
  groupHeader: {
    fontSize: 20,
    marginBottom: 20,
  },
  group: {
    margin: 20,
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 20,
  },
  container: {
    flex: 1,
    backgroundColor: '#eee',
  },
  view: {
    flex: 1,
    height: 200,
  },
};
