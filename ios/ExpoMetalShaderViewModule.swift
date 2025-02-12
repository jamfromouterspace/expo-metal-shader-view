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
                view.updateShader(newShader: shader)
            }
            
//            Prop("isPaused") { (view: ExpoMetalShaderView, isPaused: Bool) in
//                                view.mslView.setIsPaused(isPaused)
//            }
            
//            Prop("uniforms") { (view: ExpoMetalShaderView, uniforms: [String: Any]) in
//                do {
//                    //                    let iTime = try convertFloat(uniforms["iTime"])
//                    let var1 = try convertFloat(uniforms["var1"])
//                    let var2 = try convertFloat(uniforms["var2"])
//                    let var3 = try convertFloat(uniforms["var3"])
//                    let var4 = try convertInt(uniforms["var4"])
//                    let var5 = try convertInt(uniforms["var5"])
//                    let var6 = try convertBool(uniforms["var6"])
//                    
//                    let iResolution = SIMD2<Float>(
//                        uniforms["iResolutionX"] as! Float,
//                        uniforms["iResolutionY"] as! Float
//                    )
//                    let uniforms = Uniforms(
//                        iTime: 0, // This is not used - see ShaderView
//                        iResolution: iResolution,
//                        var1: var1,
//                        var2: var2,
//                        var3: var3,
//                        var4: var4,
//                        var5: var5,
//                        var6: var6
//                    )
//                    
//                    view.updateUniforms(newUniforms: uniforms)
//                } catch {
//                    // todo: send event
//                }
//            }
            
            AsyncFunction("updateUniforms") { (view: ExpoMetalShaderView, newUniforms: [String: Any]) in
                // Convert your `[String: Any]` into a `Uniforms` struct
                do {
                    let uniforms = try parseUniforms(dict: newUniforms)
                    // Push to the view WITHOUT causing SwiftUI re-render (see next steps)
                    view.updateUniforms(newUniforms: uniforms)
                } catch {
                    // handle error
                    print("Failed to parse uniforms \(error)")
                }
            }
            
            Events("onError")
        }
    }
}

// Helper for converting `[String: Any]` -> `Uniforms`
func parseUniforms(dict: [String: Any]) throws -> Uniforms {
    // Same logic you used in your Prop("uniforms") method
    let varFloat1 = try convertFloat(dict["varFloat1"])
    let varFloat2 = try convertFloat(dict["varFloat2"])
    let varFloat3 = try convertFloat(dict["varFloat3"])
    let varCumulativeFloat1 = try convertFloat(dict["varCumulativeFloat1"])
    let varCumulativeFloat2 = try convertFloat(dict["varCumulativeFloat2"])
    let varCumulativeFloat3 = try convertFloat(dict["varCumulativeFloat3"])
    let varInt1 = try convertInt(dict["varInt1"])
    let varInt2 = try convertInt(dict["varInt2"])
    let varInt3 = try convertInt(dict["varInt3"])
    let varBool1 = try convertBool(dict["varBool1"])
    let varBool2 = try convertBool(dict["varBool2"])
    let varBool3 = try convertBool(dict["varBool3"])
    
    // ...
    // build and return Uniforms struct
    return Uniforms(
        iTime: 0, // or whatever
        iResolution: SIMD2<Float>(
            dict["iResolutionX"] as? Float ?? 1024,
            dict["iResolutionY"] as? Float ?? 768
        ),
        varFloat1: varFloat1,
        varFloat2: varFloat2,
        varFloat3: varFloat3,
        varCumulativeFloat1: varCumulativeFloat1,
        varCumulativeFloat2: varCumulativeFloat2,
        varCumulativeFloat3: varCumulativeFloat3,
        //    varFloatArray: SIMD32<Float>(repeating: 0),
        varInt1: varInt1,
        varInt2: varInt2,
        varInt3: varInt3,
        varBool1: varBool1,
        varBool2: varBool2,
        varBool3: varBool3
    )
}

enum UniformTypeError: Error {
    case invalidFloat(inputType: Any.Type)
    case invalidInt(inputType: Any.Type)
    case invalidBool(inputType: Any.Type)
}


func convertFloat(_ inputVar: Any?) throws -> Float {
    var outputVar: Float
    if let number = inputVar as? NSNumber {
        outputVar = number.floatValue
    } else if let value = inputVar as? Float {
        outputVar = value
    } else if let value = inputVar as? Int {
        outputVar = Float(value)
    } else {
        throw UniformTypeError.invalidFloat(inputType: type(of: inputVar))
    }
    return outputVar
}


func convertInt(_ inputVar: Any?) throws -> Int32 {
    var outputVar: Int32
    if let number = inputVar as? NSNumber {
        outputVar = Int32(number.intValue)
    } else if let value = inputVar as? Int {
        outputVar = Int32(value)
    } else if let value = inputVar as? Float {
        outputVar = Int32(value)
    } else {
        throw UniformTypeError.invalidInt(inputType: type(of: inputVar))
    }
    return outputVar
}


func convertBool(_ inputVar: Any?) throws -> Bool {
    var outputVar: Bool
    if let number = inputVar as? NSNumber {
        outputVar = number.boolValue
    } else if let value = inputVar as? Bool {
        outputVar = value
    } else if let value = inputVar as? Int {
        outputVar = value == 0 ? false : true
    } else {
        throw UniformTypeError.invalidBool(inputType: type(of: inputVar))
    }
    return outputVar
}

