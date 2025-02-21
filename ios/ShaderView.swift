import SwiftUI

struct ShaderView: View {
    @ObservedObject var model: UniformsModel

    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        MSLViewSwiftUI(shader: model.shader, uniforms: model.uniforms, onError: model.onError)
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
                
                model.uniforms.color1 = model.pendingUniforms.color1
                model.uniforms.color2 = model.pendingUniforms.color2
                model.uniforms.color3 = model.pendingUniforms.color3
                              
                model.uniforms.intensity1 = model.pendingUniforms.intensity1
                model.uniforms.intensity2 = model.pendingUniforms.intensity2
                model.uniforms.intensity3 = model.pendingUniforms.intensity3

                model.uniforms.moveToMusic = model.pendingUniforms.moveToMusic
                
                // For the FFT array, we can interpolate each bin:
                                // (only if you want a smooth “fading” effect for each band)
            let nextSpectrum = gaussianBlur(input: model.spectrum, radius: 2, sigma: 1.0)
            for i in 0..<64 {
                model.uniforms.spectrum[i] = smoothStep(
                    current: model.uniforms.spectrum[i],
                    target: nextSpectrum[i], // presumably your new data
                    step: 0.3  // might want faster interpolation here
                )
            }
            
            // After updating the raw spectrum, compute bass from the first X bins
            let bassRange = 14
            var bassSum: Float = 0
            for i in 0..<bassRange {
                bassSum += model.uniforms.spectrum[i]
            }
            model.uniforms.bass = bassSum / Float(bassRange)

            // Now we either add or smoothly approach the cumulative bass
            // For example, an additive approach:
            model.uniforms.cumulativeBass += model.uniforms.bass

                print("updating bass", model.uniforms.bass)
            }
            .edgesIgnoringSafeArea(.all)
    }
    
}


func smoothStep(current: Float, target: Float, step: Float) -> Float {
  return current + step * (target - current)
}


/// 1D Gaussian blur on an array of Floats.
/// - Parameters:
///   - input: The input array (e.g. your FFT spectrum).
///   - radius: The 'half-width' of the blur. Kernel size will be `2*radius + 1`.
///   - sigma: Standard deviation of the Gaussian curve. Larger => smoother blur.
/// - Returns: A new array of blurred values, same size as input.
func gaussianBlur(input: FixedArray64<Float>, radius: Int, sigma: Double) -> FixedArray64<Float> {
//    guard input.count > 0 else { return [] }
    guard radius > 0 else { return input } // No blur if radius = 0

    // 1. Build the kernel (size = 2*radius + 1).
    let kernelSize = 2 * radius + 1
    var kernel = [Double](repeating: 0, count: kernelSize)
    
    // Precompute constants.
    let sigma2 = 2.0 * sigma * sigma
    let denom = sqrt(.pi * sigma2)
    
    // Fill in the kernel with the Gaussian function.
    var sum: Double = 0
    for i in 0..<kernelSize {
        let x = Double(i - radius)
        let g = exp(-(x * x) / sigma2) / denom
        kernel[i] = g
        sum += g
    }
    
    // Normalize the kernel so it sums to 1.
    for i in 0..<kernelSize {
        kernel[i] /= sum
    }
    
    // 2. Convolve the input array with the kernel.
    var output = FixedArray64<Float>(repeating: 0.0)
    for i in 0..<64 {
        var accum: Double = 0
        for j in -radius...radius {
            let index = i + j
            if index >= 0 && index < 64 {
                let w = kernel[j + radius]
                accum += w * Double(input[index])
            }
        }
        output[i] = Float(accum)
    }
    
    return output
}
