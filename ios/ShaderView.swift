import SwiftUI

struct ShaderView: View {
    @ObservedObject var model: UniformsModel
    public var var1: Float = 0.0

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        MSLViewSwiftUI(shader: model.shader, uniforms: model.uniforms)
            .onReceive(timer) { time in
                if model.isPaused {
                    return
                }
                model.uniforms.iTime += 1/60
                model.uniforms.iResolution = model.pendingUniforms.iResolution
                
                model.uniforms.varFloat1 = model.pendingUniforms.varFloat1
                model.uniforms.varFloat2 = model.pendingUniforms.varFloat2
                model.uniforms.varFloat3 = model.pendingUniforms.varFloat3
                
                model.uniforms.varCumulativeFloat1 += model.pendingUniforms.varCumulativeFloat1
                model.uniforms.varCumulativeFloat2 += model.pendingUniforms.varCumulativeFloat2
                model.uniforms.varCumulativeFloat3 += model.pendingUniforms.varCumulativeFloat3
                
                model.uniforms.varInt1 = model.pendingUniforms.varInt1
                model.uniforms.varInt2 = model.pendingUniforms.varInt2
                model.uniforms.varInt3 = model.pendingUniforms.varInt3
                
                model.uniforms.varBool1 = model.pendingUniforms.varBool1
                model.uniforms.varBool2 = model.pendingUniforms.varBool2
                model.uniforms.varBool3 = model.pendingUniforms.varBool3
                                
                model.uniforms.color1R = model.pendingUniforms.color1R
                model.uniforms.color1G = model.pendingUniforms.color1G
                model.uniforms.color1B = model.pendingUniforms.color1B
                
                model.uniforms.color2R = model.pendingUniforms.color2R
                model.uniforms.color2G = model.pendingUniforms.color2G
                model.uniforms.color2B = model.pendingUniforms.color2B
                
                model.uniforms.color3R = model.pendingUniforms.color3R
                model.uniforms.color3G = model.pendingUniforms.color3G
                model.uniforms.color3B = model.pendingUniforms.color3B
                                
                model.uniforms.intensity1 = model.pendingUniforms.intensity1
                model.uniforms.intensity2 = model.pendingUniforms.intensity2
                model.uniforms.intensity3 = model.pendingUniforms.intensity3
                
                model.uniforms.bass = model.pendingUniforms.bass
                model.uniforms.cumulativeBass += model.pendingUniforms.cumulativeBass
                
                model.uniforms.spectrum = model.pendingUniforms.spectrum
            }
            .edgesIgnoringSafeArea(.all)
    }
    
}
