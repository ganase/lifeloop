import AppKit
import AVFoundation
import Foundation

enum VideoError: Error, CustomStringConvertible {
    case cannotCreateWriter(String)
    case cannotCreatePixelBuffer
    case cannotCreatePixelBufferPool
    case cannotCreateContext
    case appendFailed
    case writerFailed(String)
    case cannotCreateImage
    case cannotWritePoster(String)

    var description: String {
        switch self {
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
        case .cannotCreateImage:
            return "Cannot create storyboard image"
        case .cannotWritePoster(let path):
            return "Cannot write poster: \(path)"
        }
    }
}

struct Scene {
    let step: String
    let title: String
    let body: String
    let phoneTitle: String
    let rows: [String]
    let emphasis: String
    let watchTitle: String?
    let watchBody: String?
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputURL = root.appendingPathComponent("docs/lifeloop/assets/lifeloop-beta-preview.mp4")
let posterURL = root.appendingPathComponent("docs/lifeloop/assets/lifeloop-workflow-poster.png")
let width = 1080
let height = 1920
let fps: Int32 = 12
let secondsPerScene = 1.85

let scenes: [Scene] = [
    Scene(
        step: "1. Place",
        title: "調布駅を経由駅として登録",
        body: "よく通る場所をPlaceに追加します。到着・離脱の判定半径を設定します。",
        phoneTitle: "Place",
        rows: ["調布駅", "カテゴリ: 経由駅", "通知条件: 到着したとき", "半径: 200m"],
        emphasis: "場所が通知のきっかけに",
        watchTitle: nil,
        watchBody: nil
    ),
    Scene(
        step: "2. Act",
        title: "ニュースチェックをActに登録",
        body: "その場所で思い出したい小さな行動をActとして登録します。",
        phoneTitle: "Act",
        rows: ["ニュースチェック", "所要時間: 3分", "カテゴリ: 仕事準備", "メモ: 主要ニュースを確認"],
        emphasis: "通知したい行動を登録",
        watchTitle: nil,
        watchBody: nil
    ),
    Scene(
        step: "3. Step",
        title: "PlaceとActをStepでつなぐ",
        body: "調布駅に着いたらニュースチェック、という条件をStepで作ります。",
        phoneTitle: "Step",
        rows: ["場所: 調布駅", "きっかけ: 到着", "Act: ニュースチェック", "曜日: 平日"],
        emphasis: "場所と行動をつなぐ",
        watchTitle: nil,
        watchBody: nil
    ),
    Scene(
        step: "4. Course",
        title: "毎朝の仕事チェックにまとめる",
        body: "関連するStepをCourseにまとめると、朝の流れとして見直せます。",
        phoneTitle: "Course",
        rows: ["毎朝の仕事チェック", "Step 1: 調布駅でニュースチェック", "有効時間: 7:00 - 10:00", "状態: 有効"],
        emphasis: "毎朝の流れとして管理",
        watchTitle: nil,
        watchBody: nil
    ),
    Scene(
        step: "5. Notification",
        title: "調布駅に着くと通知",
        body: "iPhoneを閉じていても、許可されたローカル通知で次の行動を知らせます。",
        phoneTitle: "通知",
        rows: ["lifeloop", "調布駅に着きました", "ニュースチェック", "毎朝の仕事チェック"],
        emphasis: "通知をタップしてLogへ",
        watchTitle: "lifeloop",
        watchBody: "調布駅に着きました\nニュースチェック"
    ),
    Scene(
        step: "6. Log",
        title: "実施結果を記録",
        body: "実施、非実施、スヌーズを残すと、あとで日ごとの状況を確認できます。",
        phoneTitle: "Log",
        rows: ["ニュースチェック", "結果: 実施", "時刻: 8:12", "Course: 毎朝の仕事チェック"],
        emphasis: "小さな行動を記録して続ける",
        watchTitle: nil,
        watchBody: nil
    ),
]

func color(_ hex: UInt32) -> NSColor {
    NSColor(
        calibratedRed: CGFloat((hex >> 16) & 0xff) / 255,
        green: CGFloat((hex >> 8) & 0xff) / 255,
        blue: CGFloat(hex & 0xff) / 255,
        alpha: 1
    )
}

func rectFromTop(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    CGRect(x: x, y: CGFloat(height) - y - height, width: width, height: height)
}

func drawText(_ text: String, in rect: CGRect, size: CGFloat, weight: NSFont.Weight = .regular, color textColor: NSColor = color(0x172033), alignment: NSTextAlignment = .left) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineSpacing = 5
    paragraph.lineBreakMode = .byWordWrapping
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size, weight: weight),
        .foregroundColor: textColor,
        .paragraphStyle: paragraph,
    ]
    NSString(string: text).draw(in: rect, withAttributes: attributes)
}

func roundedRect(_ rect: CGRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

func drawPhone(scene: Scene, frame: CGRect) {
    roundedRect(frame, radius: 72, fill: color(0xf8fafc), stroke: color(0xd9e2ec), lineWidth: 4)
    roundedRect(CGRect(x: frame.midX - 92, y: frame.maxY - 72, width: 184, height: 36), radius: 18, fill: .black)

    drawText("9:41", in: CGRect(x: frame.minX + 58, y: frame.maxY - 76, width: 110, height: 34), size: 26, weight: .semibold)
    drawText("lifeloop", in: CGRect(x: frame.minX + 46, y: frame.maxY - 150, width: frame.width - 92, height: 40), size: 28, weight: .semibold, alignment: .center)

    let card = CGRect(x: frame.minX + 44, y: frame.minY + 190, width: frame.width - 88, height: frame.height - 290)
    roundedRect(card, radius: 28, fill: .white, stroke: color(0xe4e9f0), lineWidth: 2)
    drawText(scene.phoneTitle, in: CGRect(x: card.minX + 38, y: card.maxY - 86, width: card.width - 76, height: 42), size: 34, weight: .bold)

    var y = card.maxY - 168
    for row in scene.rows {
        let rowRect = CGRect(x: card.minX + 32, y: y, width: card.width - 64, height: 72)
        roundedRect(rowRect, radius: 20, fill: color(0xf3f7fb), stroke: color(0xe5ebf3), lineWidth: 1)
        drawText(row, in: CGRect(x: rowRect.minX + 24, y: rowRect.minY + 18, width: rowRect.width - 48, height: 36), size: 25, weight: row == scene.rows.first ? .semibold : .regular)
        y -= 88
    }

    let emphasisRect = CGRect(x: card.minX + 32, y: card.minY + 44, width: card.width - 64, height: 84)
    roundedRect(emphasisRect, radius: 24, fill: color(0xe7f1ff), stroke: color(0x91c5ff), lineWidth: 2)
    drawText(scene.emphasis, in: CGRect(x: emphasisRect.minX + 22, y: emphasisRect.minY + 25, width: emphasisRect.width - 44, height: 36), size: 24, weight: .semibold, color: color(0x07539a), alignment: .center)

    let tabBar = CGRect(x: frame.minX + 54, y: frame.minY + 42, width: frame.width - 108, height: 86)
    roundedRect(tabBar, radius: 38, fill: color(0xf0f4f8), stroke: color(0xdce6ef), lineWidth: 1)
    let tabs = ["Home", "Place", "Act", "Steps", "Log"]
    for (index, tab) in tabs.enumerated() {
        drawText(tab, in: CGRect(x: tabBar.minX + CGFloat(index) * tabBar.width / 5, y: tabBar.minY + 28, width: tabBar.width / 5, height: 28), size: 17, weight: tab == scene.phoneTitle || (scene.phoneTitle == "通知" && tab == "Home") ? .bold : .regular, color: tab == scene.phoneTitle ? color(0x0876dd) : color(0x52606d), alignment: .center)
    }
}

func drawWatch(title: String, body: String, frame: CGRect) {
    roundedRect(frame, radius: 96, fill: color(0x121826), stroke: color(0x2e3a4f), lineWidth: 6)
    let screen = frame.insetBy(dx: 30, dy: 42)
    roundedRect(screen, radius: 70, fill: color(0x1d2637))
    drawText(title, in: CGRect(x: screen.minX + 32, y: screen.maxY - 90, width: screen.width - 64, height: 32), size: 25, weight: .semibold, color: .white, alignment: .center)
    drawText(body, in: CGRect(x: screen.minX + 34, y: screen.maxY - 220, width: screen.width - 68, height: 116), size: 29, weight: .semibold, color: .white, alignment: .center)
    let button = CGRect(x: screen.minX + 58, y: screen.minY + 58, width: screen.width - 116, height: 52)
    roundedRect(button, radius: 26, fill: color(0x1683f5))
    drawText("開く", in: CGRect(x: button.minX, y: button.minY + 11, width: button.width, height: 28), size: 22, weight: .semibold, color: .white, alignment: .center)
}

func makeSceneImage(_ scene: Scene) throws -> CGImage {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw VideoError.cannotCreateImage
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    defer { NSGraphicsContext.restoreGraphicsState() }

    color(0xf4f7f5).setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()

    roundedRect(CGRect(x: -120, y: 1450, width: 520, height: 520), radius: 260, fill: color(0xd9ebff))
    roundedRect(CGRect(x: 760, y: -130, width: 440, height: 440), radius: 220, fill: color(0xe3f1fb))

    drawText(scene.step, in: CGRect(x: 96, y: 1660, width: 320, height: 44), size: 28, weight: .bold, color: color(0x0876dd))
    drawText(scene.title, in: CGRect(x: 96, y: 1532, width: 888, height: 96), size: 50, weight: .bold)
    drawText(scene.body, in: CGRect(x: 96, y: 1446, width: 880, height: 78), size: 27, color: color(0x52606d))

    drawPhone(scene: scene, frame: CGRect(x: 98, y: 132, width: 568, height: 1220))

    if let watchTitle = scene.watchTitle, let watchBody = scene.watchBody {
        drawWatch(title: watchTitle, body: watchBody, frame: CGRect(x: 712, y: 570, width: 268, height: 330))
        drawText("Apple Watchにも通知", in: CGRect(x: 690, y: 485, width: 320, height: 40), size: 25, weight: .semibold, color: color(0x172033), alignment: .center)
    } else {
        let side = CGRect(x: 720, y: 400, width: 280, height: 620)
        roundedRect(side, radius: 36, fill: .white, stroke: color(0xdde6ef), lineWidth: 2)
        drawText("次にやること", in: CGRect(x: side.minX + 34, y: side.maxY - 92, width: side.width - 68, height: 34), size: 24, weight: .bold, color: color(0x52606d))
        drawText(scene.emphasis, in: CGRect(x: side.minX + 34, y: side.maxY - 220, width: side.width - 68, height: 110), size: 30, weight: .bold, color: color(0x172033), alignment: .center)
        roundedRect(CGRect(x: side.minX + 70, y: side.minY + 74, width: side.width - 140, height: 12), radius: 6, fill: color(0x1683f5))
        drawText(scene.step, in: CGRect(x: side.minX + 30, y: side.minY + 120, width: side.width - 60, height: 32), size: 20, weight: .semibold, color: color(0x0876dd), alignment: .center)
    }

    guard let cgImage = bitmap.cgImage else {
        throw VideoError.cannotCreateImage
    }
    return cgImage
}

func writePoster(_ image: CGImage) throws {
    let bitmap = NSBitmapImageRep(cgImage: image)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw VideoError.cannotWritePoster(posterURL.path)
    }
    try data.write(to: posterURL, options: [.atomic])
}

func makePixelBuffer(from image: CGImage, pool: CVPixelBufferPool) throws -> CVPixelBuffer {
    var buffer: CVPixelBuffer?
    let createStatus = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &buffer)
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

    context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    return pixelBuffer
}

do {
    let images = try scenes.map(makeSceneImage)
    if let first = images.first {
        try writePoster(first)
    }

    try? FileManager.default.removeItem(at: outputURL)
    guard let writer = try? AVAssetWriter(outputURL: outputURL, fileType: .mp4) else {
        throw VideoError.cannotCreateWriter(outputURL.path)
    }

    let outputSettings: [String: Any] = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: width,
        AVVideoHeightKey: height,
        AVVideoCompressionPropertiesKey: [
            AVVideoAverageBitRateKey: 4_800_000,
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

    let framesPerScene = Int(round(secondsPerScene * Double(fps)))
    var frameIndex: Int64 = 0
    for image in images {
        for _ in 0..<framesPerScene {
            while !input.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.01)
            }
            let pixelBuffer = try makePixelBuffer(from: image, pool: pixelBufferPool)
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
    print("Wrote \(posterURL.path)")
} catch {
    fputs("\(error)\n", stderr)
    exit(1)
}
