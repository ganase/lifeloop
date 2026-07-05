import AppKit
import AVFoundation
import Foundation

enum VideoError: Error, CustomStringConvertible {
    case missingImage(String)
    case invalidImage(String)
    case cannotCreateWriter(String)
    case cannotCreatePixelBuffer
    case cannotCreatePixelBufferPool
    case cannotCreateContext
    case appendFailed
    case writerFailed(String)

    var description: String {
        switch self {
        case .missingImage(let path):
            return "Missing image: \(path)"
        case .invalidImage(let path):
            return "Invalid image: \(path)"
        case .cannotCreateWriter(let path):
            return "Cannot create video writer: \(path)"
        case .cannotCreatePixelBuffer:
            return "Cannot create pixel buffer"
        case .cannotCreatePixelBufferPool:
            return "Cannot create pixel buffer pool"
        case .cannotCreateContext:
            return "Cannot create drawing context"
        case .appendFailed:
            return "Could not append frame"
        case .writerFailed(let message):
            return "Video writer failed: \(message)"
        }
    }
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let screenPaths = [
    "docs/lifeloop/assets/screens/01-home-map.png",
    "docs/lifeloop/assets/screens/02-place.png",
    "docs/lifeloop/assets/screens/03-act.png",
    "docs/lifeloop/assets/screens/04-steps.png",
    "docs/lifeloop/assets/screens/05-log.png",
]
let outputURL = root.appendingPathComponent("docs/lifeloop/assets/lifeloop-beta-preview.mp4")
let fps: Int32 = 10
let secondsPerScreen = 1.6

func loadImage(at relativePath: String) throws -> CGImage {
    let url = root.appendingPathComponent(relativePath)
    guard FileManager.default.fileExists(atPath: url.path) else {
        throw VideoError.missingImage(relativePath)
    }
    guard let image = NSImage(contentsOf: url) else {
        throw VideoError.invalidImage(relativePath)
    }
    var rect = CGRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
        throw VideoError.invalidImage(relativePath)
    }
    return cgImage
}

func makePixelBuffer(from image: CGImage, width: Int, height: Int, pool: CVPixelBufferPool) throws -> CVPixelBuffer {
    var buffer: CVPixelBuffer?
    let createStatus = CVPixelBufferPoolCreatePixelBuffer(
        kCFAllocatorDefault,
        pool,
        &buffer
    )
    guard createStatus == kCVReturnSuccess, let pixelBuffer = buffer else {
        throw VideoError.cannotCreatePixelBuffer
    }

    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

    guard
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer),
        let context = CGContext(
            data: baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        )
    else {
        throw VideoError.cannotCreateContext
    }

    context.setFillColor(CGColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    let imageAspect = CGFloat(image.width) / CGFloat(image.height)
    let canvasAspect = CGFloat(width) / CGFloat(height)
    let drawSize: CGSize
    if imageAspect > canvasAspect {
        let drawWidth = CGFloat(width)
        drawSize = CGSize(width: drawWidth, height: drawWidth / imageAspect)
    } else {
        let drawHeight = CGFloat(height)
        drawSize = CGSize(width: drawHeight * imageAspect, height: drawHeight)
    }
    let drawRect = CGRect(
        x: (CGFloat(width) - drawSize.width) / 2,
        y: (CGFloat(height) - drawSize.height) / 2,
        width: drawSize.width,
        height: drawSize.height
    )
    context.draw(image, in: drawRect)
    return pixelBuffer
}

do {
    let images = try screenPaths.map(loadImage)
    guard let firstImage = images.first else {
        throw VideoError.invalidImage("no input images")
    }

    let width = Int(ceil(Double(firstImage.width) / 16.0) * 16.0)
    let height = Int(ceil(Double(firstImage.height) / 16.0) * 16.0)
    try? FileManager.default.removeItem(at: outputURL)

    guard let writer = try? AVAssetWriter(outputURL: outputURL, fileType: .mp4) else {
        throw VideoError.cannotCreateWriter(outputURL.path)
    }

    let outputSettings: [String: Any] = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoCompressionPropertiesKey: [
            AVVideoAverageBitRateKey: 1_800_000,
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
        ],
    ]
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
    input.expectsMediaDataInRealTime = false

    let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: input,
        sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:],
        ]
    )

    guard writer.canAdd(input) else {
        throw VideoError.cannotCreateWriter(outputURL.path)
    }
    writer.add(input)

    guard writer.startWriting() else {
        throw VideoError.writerFailed(writer.error?.localizedDescription ?? "could not start writing")
    }
    writer.startSession(atSourceTime: .zero)
    guard let pixelBufferPool = adaptor.pixelBufferPool else {
        throw VideoError.cannotCreatePixelBufferPool
    }

    let framesPerScreen = Int(round(secondsPerScreen * Double(fps)))
    var frameIndex: Int64 = 0

    for image in images {
        for _ in 0..<framesPerScreen {
            while !input.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.01)
            }
            let pixelBuffer = try makePixelBuffer(from: image, width: width, height: height, pool: pixelBufferPool)
            let time = CMTime(value: frameIndex, timescale: fps)
            guard adaptor.append(pixelBuffer, withPresentationTime: time) else {
                throw VideoError.appendFailed
            }
            frameIndex += 1
        }
    }

    input.markAsFinished()
    let semaphore = DispatchSemaphore(value: 0)
    writer.finishWriting {
        semaphore.signal()
    }
    semaphore.wait()

    if writer.status == .failed {
        throw VideoError.writerFailed(writer.error?.localizedDescription ?? "unknown error")
    }

    print("Wrote \(outputURL.path)")
} catch {
    fputs("\(error)\n", stderr)
    exit(1)
}
