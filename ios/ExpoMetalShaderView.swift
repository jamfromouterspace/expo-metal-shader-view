import ExpoModulesCore

let DEFAULT_SHADER = """
    fragment float4 mainImage() {
        return float4(0.0, 0.0, 0.0, 1.0);
    }
"""

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

// This view will be used as a native component. Make sure to inherit from `ExpoView`
// to apply the proper styling (e.g. border radius and shadows).
class ExpoMetalShaderView: ExpoView {
    let mslView: MSLView<Uniforms>!
    let onError = EventDispatcher()
    
    required init(appContext: AppContext? = nil) {
        let uniforms = Uniforms(iTime: 0, iResolution: SIMD2<Float>(), var1: 0, var2: 0, var3: 0, var4: 0, var5: 0, var6: false)
        self.mslView = MSLView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024), shader: DEFAULT_SHADER, uniforms: uniforms)
        super.init(appContext: appContext)
        clipsToBounds = true
        self.mslView.frame = bounds
        addSubview(mslView)
    }
    
    override func layoutSubviews() {
        mslView.frame = bounds
    }
}
