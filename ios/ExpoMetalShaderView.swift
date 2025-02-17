import ExpoModulesCore
import SwiftUI
import UIKit

import SwiftUI
import simd

let DEFAULT_SHADER = """
    fragment float4 mainImage() {
        return float4(0.0, 0.0, 0.0, 1.0);
    }
"""

struct Uniforms {
    var iTime: Float
    var iResolution: SIMD2<Float>
    var varFloat1: Float
    var varFloat2: Float
    var varFloat3: Float
    var varCumulativeFloat1: Float
    var varCumulativeFloat2: Float
    var varCumulativeFloat3: Float
    var varInt1: Int
    var varInt2: Int
    var varInt3: Int
    var varBool1: Bool
    var varBool2: Bool
    var varBool3: Bool

    var color1R: Float
    var color1G: Float
    var color1B: Float
    
    var color2R: Float
    var color2G: Float
    var color2B: Float
    
    var color3R: Float
    var color3G: Float
    var color3B: Float
    
    var intensity1: Float
    var intensity2: Float
    var intensity3: Float
    
    var cumulativeBass: Float
    var bass: Float
    
    var spectrum: SIMD64<Float>
}

class UniformsModel: ObservableObject {
  // The uniforms actually used by the shader (causes SwiftUI updates)
  @Published var uniforms: Uniforms
  
  // A non-published copy that won’t trigger any view updates
  var pendingUniforms: Uniforms
  
  @Published var shader: String
    
  @Published var isPaused: Bool
  
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
      varInt1: 0,
      varInt2: 0,
      varInt3: 0,
      varBool1: false,
      varBool2: false,
      varBool3: false,
      
      color1R: 0,
      color1G: 0,
      color1B: 0,
      
      color2R: 0,
      color2G: 0,
      color2B: 0,
      
      color3R: 0,
      color3G: 0,
      color3B: 0,
      
      intensity1: 0,
      intensity2: 0,
      intensity3: 0,
      
      cumulativeBass: 0,
      bass: 0,
      
      spectrum: SIMD64<Float>(repeating: 0.0)
    )
    
    self.uniforms = defaultUniforms
    self.pendingUniforms = defaultUniforms
    self.shader = DEFAULT_SHADER
      self.isPaused = false
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
    
    func updateIsPaused(isPaused: Bool) {
        DispatchQueue.main.async {
            self.uniformsModel.isPaused = isPaused
        }
    }
}
