import SwiftUI

struct ShaderView: View {
    @ObservedObject var model: UniformsModel

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        MSLViewSwiftUI(shader: model.shader, uniforms: model.uniforms)
            .onReceive(timer) { time in
                model.uniforms.iTime += 1/60
            }
    }
    
}
