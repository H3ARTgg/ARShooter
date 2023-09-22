import AVFoundation

final class VideoManager {
    static func getGameplayPlayer() -> AVPlayer? {
        guard let url = Bundle.main.url(forResource: Consts.gameplayVideo, withExtension: "mp4") else { return AVPlayer() }
        let player = AVPlayer(url: url)
        player.play()
        return player
    }
}
