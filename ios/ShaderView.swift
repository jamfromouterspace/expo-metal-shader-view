import SwiftUI

struct ShaderView: View {
    @ObservedObject var model: UniformsModel
    public var var1: Float = 0.0

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        MSLViewSwiftUI(shader: model.shader, uniforms: model.uniforms)
            .onReceive(timer) { time in
                model.uniforms.iTime += 1/60
                model.uniforms.iResolution = model.pendingUniforms.iResolution
                
                model.uniforms.varFloat1 = model.pendingUniforms.varFloat1
                model.uniforms.varFloat2 = model.pendingUniforms.varFloat2
                model.uniforms.varFloat3 = model.pendingUniforms.varFloat3
                
                model.uniforms.varCumulativeFloat1 += model.pendingUniforms.varCumulativeFloat1
                model.uniforms.varCumulativeFloat2 += model.pendingUniforms.varCumulativeFloat2
                model.uniforms.varCumulativeFloat3 += model.pendingUniforms.varCumulativeFloat3
                
//                model.uniforms.varFloatArray = model.pendingUniforms.varFloatArray
                
                model.uniforms.varInt1 = model.pendingUniforms.varInt1
                model.uniforms.varInt2 = model.pendingUniforms.varInt2
                model.uniforms.varInt3 = model.pendingUniforms.varInt3
                
                model.uniforms.varBool1 = model.pendingUniforms.varBool1
                model.uniforms.varBool2 = model.pendingUniforms.varBool2
                model.uniforms.varBool3 = model.pendingUniforms.varBool3
                
            }
            .edgesIgnoringSafeArea(.all)
    }
    
}
