//import ExpoModulesCore
//
let DEFAULT_SHADER = """
    fragment float4 mainImage() {
        return float4(0.0, 0.0, 0.0, 1.0);
    }
"""
//
struct Uniforms {
    var iTime: Float
    var iResolution: SIMD2<Float>
    var varFloat1: Float
    var varFloat2: Float
    var varFloat3: Float
    var varCumulativeFloat1: Float
    var varCumulativeFloat2: Float
    var varCumulativeFloat3: Float
//    var varFloatArray: SIMD32<Float>
    var varInt1: Int32
    var varInt2: Int32
    var varInt3: Int32
    var varBool1: Bool
    var varBool2: Bool
    var varBool3: Bool
}

import ExpoModulesCore
import SwiftUI
import UIKit

import SwiftUI
import simd

class UniformsModel: ObservableObject {
  // The uniforms actually used by the shader (causes SwiftUI updates)
  @Published var uniforms: Uniforms
  
  // A non-published copy that won’t trigger any view updates
  var pendingUniforms: Uniforms
  
  @Published var shader: String
  
  init() {
    let defaultUniforms = Uniforms(
      iTime: 0.0,
      iResolution: SIMD2<Float>(1024, 768),
      varFloat1: 0.0,
      varFloat2: 0.0,
      varFloat3: 0.0,
      varCumulativeFloat1: 0.0,
      varCumulativeFloat2: 0.0,
      varCumulativeFloat3: 0.0,
//      varFloatArray: SIMD32<Float>(repeating: 0.0),
      varInt1: 0,
      varInt2: 0,
      varInt3: 0,
      varBool1: false,
      varBool2: false,
      varBool3: false
    )
    
    self.uniforms = defaultUniforms
    self.pendingUniforms = defaultUniforms
    self.shader = DEFAULT_SHADER
  }
}

class ExpoMetalShaderView: ExpoView {
    
    private let contentView: UIHostingController<ShaderView>
    
    private let uniformsModel = UniformsModel()
    
    required init(appContext: AppContext? = nil) {
        contentView = UIHostingController(rootView: ShaderView(model: uniformsModel))
        contentView.view.backgroundColor = UIColor.clear
        super.init(appContext: appContext)
        
        // clipsToBounds = true
        addSubview(contentView.view)
    }
    
    override func layoutSubviews() {
        contentView.view.frame = bounds
    }
    
    func updateUniforms(newUniforms: Uniforms) {
        DispatchQueue.main.async {
            self.uniformsModel.pendingUniforms = newUniforms
        }
    }
    
    func updateShader(newShader: String) {
        DispatchQueue.main.async {
            self.uniformsModel.shader = newShader
        }
    }
}
