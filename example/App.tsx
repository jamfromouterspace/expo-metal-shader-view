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
      struct Uniforms {
        float iTime;
        float2 iResolution;
        float var1;
        float var2;
        float var3;
        int var4;
        int var5;
        bool var6;
      };

      fragment float4 mainImage(FragmentIn input [[stage_in]],
                               constant Uniforms& c,
                               constant uint2& viewSize) {
            return float4(c.var1, 0.0, 0.0, 1.0);
        }
    `
  }, [])

  
  const shaderRef = useRef<ExpoMetalShaderViewRef>(null)

  useEffect(() => {
    // use shaderRef.current?.updateUniforms() to update the uniforms
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
