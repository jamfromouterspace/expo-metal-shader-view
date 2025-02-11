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
                do {
                    let iTime = try convertFloat(uniforms["iTime"])
                    let var1 = try convertFloat(uniforms["var1"])
                    let var2 = try convertFloat(uniforms["var2"])
                    let var3 = try convertFloat(uniforms["var3"])
                    let var4 = try convertInt(uniforms["var4"])
                    let var5 = try convertInt(uniforms["var5"])
                    let var6 = try convertBool(uniforms["var6"])
                    
                    let iResolution = SIMD2<Float>(
                        uniforms["iResolutionX"] as! Float,
                        uniforms["iResolutionY"] as! Float
                    )
                    let uniforms = Uniforms(
                        iTime: iTime,
                        iResolution: iResolution,
                        var1: var1,
                        var2: var2,
                        var3: var3,
                        var4: var4,
                        var5: var5,
                        var6: var6
                    )
                    try view.mslView.updateUniforms(uniforms: uniforms)
                } catch {
                    // todo: send event
                }
            }
            
            
            
            Events("onError")
        }
    }
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


func convertInt(_ inputVar: Any?) throws -> Int {
    var outputVar: Int
    if let number = inputVar as? NSNumber {
        outputVar = number.intValue
    } else if let value = inputVar as? Int {
        outputVar = value
    } else if let value = inputVar as? Float {
        outputVar = Int(value)
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

