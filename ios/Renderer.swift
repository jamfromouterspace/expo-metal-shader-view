import Foundation
import MetalKit

let MaxBuffers = 3

class Renderer<T>: NSObject, MTKViewDelegate {

    var device: MTLDevice!
    var queue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState!
    var source = ""
    public var uniforms: T

    private let inflightSemaphore = DispatchSemaphore(value: MaxBuffers)

    init(device: MTLDevice, uniforms: T) {
        self.device = device
        queue = device.makeCommandQueue()
        self.uniforms = uniforms
    }
    
    let vertex = """
    #include <metal_stdlib>

    struct FragmentIn {
        float4 position [[ position ]];
    };

    constant float2 pos[4] = { {-1,-1}, {1,-1}, {-1,1}, {1,1 } };

    vertex FragmentIn __vertex__(uint id [[ vertex_id ]]) {
        FragmentIn out;
        out.position = float4(pos[id], 0, 1);
        return out;
    }
    """
    
    private func loadTexture(image: UIImage, rect: CGRect) throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        let imageRef = image.cgImage!.cropping(to: rect)!
        let imageData = UIImage(cgImage: imageRef).pngData()!
        return try textureLoader.newTexture(data: imageData, options: nil)
    }

    func setShader(source: String) {

        if source == self.source {
            return
        }

        self.source = source

        do {
            let library = try device.makeLibrary(source: vertex + source, options: nil)

            let rpd = MTLRenderPipelineDescriptor()
            rpd.vertexFunction = library.makeFunction(name: "__vertex__")
            rpd.fragmentFunction = library.makeFunction(name: "mainImage")
            rpd.colorAttachments[0].pixelFormat = .bgra8Unorm

            pipeline = try device.makeRenderPipelineState(descriptor: rpd)

        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func setDefaultShader() {
        
        do {
            let library = try device.makeLibrary(source: vertex, options: nil)
            let defaultLibrary = device.makeDefaultLibrary()!
            let rpd = MTLRenderPipelineDescriptor()
            rpd.vertexFunction = library.makeFunction(name: "__vertex__")
            rpd.fragmentFunction = defaultLibrary.makeFunction(name: "mainImage")
            rpd.colorAttachments[0].pixelFormat = .bgra8Unorm

            pipeline = try device.makeRenderPipelineState(descriptor: rpd)
        } catch let error {
            print("Error: \(error)")
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {

        let size = view.frame.size
        let w = Float(size.width)
        let h = Float(size.height)
        // let scale = Float(view.contentScaleFactor)

        if w == 0 || h == 0 {
            return
        }

        // use semaphore to encode 3 frames ahead
        _ = inflightSemaphore.wait(timeout: DispatchTime.distantFuture)

        let commandBuffer = queue.makeCommandBuffer()!

        let semaphore = inflightSemaphore
        commandBuffer.addCompletedHandler { _ in
            semaphore.signal()
        }


        if let renderPassDescriptor = view.currentRenderPassDescriptor, let currentDrawable = view.currentDrawable {

            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)

            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            encoder.setRenderPipelineState(pipeline)
            encoder.setFragmentBytes([uniforms], length: MemoryLayout<T>.size, index: 0)
            var size = SIMD2<Int32>(Int32(view.drawableSize.width), Int32(view.drawableSize.height))
            print("size", size)
            encoder.setFragmentBytes(&size, length: MemoryLayout<SIMD2<Int32>>.size, index: 1)
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            encoder.endEncoding()

            commandBuffer.present(currentDrawable)
        }
        commandBuffer.commit()

    }
}
