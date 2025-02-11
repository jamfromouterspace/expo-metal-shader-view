import { useEvent } from 'expo';
import { ExpoMetalShaderView, Uniforms } from 'expo-metal-shader-view';
import { useMemo } from 'react';
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

  const uniforms: Uniforms = useMemo(() => {
    return {
      iTime: 0.0,
      iResolution: [windowWidth, windowHeight],
      var1: 1.0,
      var2: 0.0,
      var3: 0,
      var4: 0,
      var5: 0,
      var6: false
    }
  }, [])

  return (
    <SafeAreaView style={styles.container}>
      <ExpoMetalShaderView
        style={{
          flex: 1,
          height: 200,
          width: "100%"
        }}
        shader={shader}
        uniforms={uniforms}
        onError={({ nativeEvent: { error } }) => console.log(`Error: ${error}`)}
        isPaused={false}
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
