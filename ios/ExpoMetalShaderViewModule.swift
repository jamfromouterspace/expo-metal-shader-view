import ExpoModulesCore

public class ExpoMetalShaderViewModule: Module {
    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoMetalShaderView')` in JavaScript.
        Name("ExpoMetalShaderView")
        
        // Enables the module to be used as a native view. Definition components that are accepted as part of the
        // view definition: Prop, Events.
        View(ExpoMetalShaderView.self) {
            // Defines a setter for the `url` prop.
            Prop("shader") { (view: ExpoMetalShaderView, shader: String) in
                view.mslView.updateShader(shader: shader)
            }
            
            Prop("isPaused") { (view: ExpoMetalShaderView, isPaused: Bool) in
                view.mslView.setIsPaused(isPaused)
            }
            
            Prop("uniforms") { (view: ExpoMetalShaderView, uniforms: [String: Any]) in
                let iTime = uniforms["iTime"] as! Float
                let iResolution = SIMD2<Float>(
                    uniforms["iResolutionX"] as! Float,
                    uniforms["iResolutionY"] as! Float
                )
                let uniforms = Uniforms(
                    iTime: iTime,
                    iResolution: iResolution,
                    var1: uniforms["var1"] as! Float,
                    var2: uniforms["var2"] as! Float,
                    var3: uniforms["var3"] as! Float,
                    var4: uniforms["var4"] as! Int,
                    var5: uniforms["var5"] as! Int,
                    var6: uniforms["var6"] as! Bool
                )
                view.mslView.updateUniforms(uniforms: uniforms)
            }
            
            
            
            Events("onError")
        }
    }
}
