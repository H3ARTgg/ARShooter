import AVKit

final class AudioManager {
    static let shared = AudioManager()
    var players: [AVAudioPlayer] = []
    
    func playCountdown() {
        playSoundFor(Consts.countdownSound)
    }
    
    func playLaserShot() {
        playSoundFor(Consts.laserShotSound)
    }
    
    func playTargetSpawn() {
        playSoundFor(Consts.targetSpawnSound)
    }
    
    private func playSoundFor(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ".mp3") else { return }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
        players.append(player)
        if soundName == Consts.targetSpawnSound {
            player.volume = 0.5
        }
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self else { return }
            self.players.removeAll {
                $0 == player
            }
        }
    }
}
