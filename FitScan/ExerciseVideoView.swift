import AVFoundation
import SwiftUI
import UIKit

/// Findet das gerenderte Übungsvideo einer Übung im App-Bundle.
enum ExerciseVideo {
    static func url(for exercise: Exercise) -> URL? {
        guard let name = exercise.videoName else { return nil }
        return Bundle.main.url(forResource: name, withExtension: "mp4", subdirectory: "ExerciseVideos")
            ?? Bundle.main.url(forResource: name, withExtension: "mp4")
    }
}

/// Spielt ein Übungsvideo stumm in Endlosschleife ab (ohne Bedienelemente).
/// Antippen pausiert bzw. setzt fort.
struct ExerciseVideoView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> LoopingPlayerView {
        let view = LoopingPlayerView()
        view.play(url: url)
        return view
    }

    func updateUIView(_ view: LoopingPlayerView, context: Context) {
        if view.currentURL != url { view.play(url: url) }
    }

    static func dismantleUIView(_ view: LoopingPlayerView, coordinator: ()) {
        view.stop()
    }
}

final class LoopingPlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private(set) var currentURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.02, green: 0.07, blue: 0.22, alpha: 1)   // Studio-Blau wie im Video
        playerLayer.videoGravity = .resizeAspect
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggle)))
        isAccessibilityElement = true
        accessibilityLabel = "Übungsvideo"
        accessibilityHint = "Doppeltippen pausiert oder setzt das Video fort."
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func play(url: URL) {
        stop()
        currentURL = url
        let item = AVPlayerItem(url: url)
        let queue = AVQueuePlayer()
        queue.isMuted = true
        queue.preventsDisplaySleepDuringVideoPlayback = false
        looper = AVPlayerLooper(player: queue, templateItem: item)
        player = queue
        playerLayer.player = queue
        queue.play()
    }

    func stop() {
        player?.pause()
        looper?.disableLooping()
        looper = nil
        player = nil
        playerLayer.player = nil
    }

    @objc private func toggle() {
        guard let p = player else { return }
        if p.timeControlStatus == .playing { p.pause() } else { p.play() }
    }
}
