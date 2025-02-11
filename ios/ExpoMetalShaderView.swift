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
    var var1: Float
    var var2: Float
    var var3: Float
    var var4: Int
    var var5: Int
    var var6: Bool
}
//
//// This view will be used as a native component. Make sure to inherit from `ExpoView`
//// to apply the proper styling (e.g. border radius and shadows).
//class ExpoMetalShaderView: ExpoView {
//    let mslView: MSLView<Uniforms>!
//    let onError = EventDispatcher()
//    private var displayTimer: Timer?
//    
//    required init(appContext: AppContext? = nil) {
//            let uniforms = Uniforms(iTime: 0,
//                                    iResolution: SIMD2<Float>(1024, 1024),
//                                    var1: 0,
//                                    var2: 0,
//                                    var3: 0,
//                                    var4: 0,
//                                    var5: 0,
//                                    var6: false)
//            self.mslView = MSLView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024),
//                                   shader: DEFAULT_SHADER,
//                                   uniforms: uniforms)
//            super.init(appContext: appContext)
//            clipsToBounds = true
//            self.mslView.frame = bounds
//            addSubview(mslView)
//
//            // Start the timer to update 'iTime' every frame (approx. 60 FPS)
//            displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
//                guard let self = self else { return }
//                // Update your uniforms; here we increment iTime
//                var newUniforms = self.mslView.uniforms
//                newUniforms.iTime += 1.0 / 60.0
//                print("time...", newUniforms.iTime)
//                self.mslView.updateUniforms(uniforms: newUniforms)
//            }
//        }
//    
//    override func layoutSubviews() {
//        mslView.frame = bounds
//    }
//    
//    deinit {
//            displayTimer?.invalidate()
//    }
//}

import ExpoModulesCore
import SwiftUI
import UIKit

import SwiftUI
import simd

class UniformsModel: ObservableObject {
    @Published var uniforms: Uniforms = Uniforms(
        iTime: 0,
        iResolution: SIMD2<Float>(1, 1),
        var1: 0.1,
        var2: 0.0,
        var3: 0.0,
        var4: 0,
        var5: 0,
        var6: false
    )
    @Published var shader: String = DEFAULT_SHADER
}

class ExpoMetalShaderView: ExpoView {
    
    private let contentView: UIHostingController<ShaderView>
    private var uniforms = Uniforms(
        iTime: 0,
        iResolution: SIMD2<Float>(1, 1),
        var1: 0.1,
        var2: 0.0,
        var3: 0.0,
        var4: 0,
        var5: 0,
        var6: false
    )
    
    private let uniformsModel = UniformsModel()
    
    required init(appContext: AppContext? = nil) {
        contentView = UIHostingController(rootView: ShaderView(model: uniformsModel))
        contentView.view.backgroundColor = UIColor.clear
        super.init(appContext: appContext)
        
        clipsToBounds = true
        addSubview(contentView.view)
    }
    
    override func layoutSubviews() {
        contentView.view.frame = bounds
    }
    
    func updateUniforms(newUniforms: Uniforms) {
        DispatchQueue.main.async {
            self.uniformsModel.uniforms.iResolution = newUniforms.iResolution
            self.uniformsModel.uniforms.var1 = newUniforms.var1
            self.uniformsModel.uniforms.var2 = newUniforms.var2
            self.uniformsModel.uniforms.var3 = newUniforms.var3
            self.uniformsModel.uniforms.var4 = newUniforms.var4
            self.uniformsModel.uniforms.var5 = newUniforms.var5
            self.uniformsModel.uniforms.var6 = newUniforms.var6
        }
    }
    
    func updateShader(newShader: String) {
        DispatchQueue.main.async {
            self.uniformsModel.shader = newShader
        }
    }
}
