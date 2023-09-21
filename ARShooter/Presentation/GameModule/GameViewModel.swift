import Foundation
import SceneKit
import Combine

protocol GameViewModelProtocol {
    var scorePublisher: AnyPublisher<Int, Never> { get }
    var timeLeftInSecondsPublisher: AnyPublisher<Double, Never> { get }
    var countdownSecondsPublisher: AnyPublisher<Double, Never> { get }
    var targetPublisher: AnyPublisher<SCNNode, Never> { get }
    var resultsPublisher: AnyPublisher<GameResults, Never> { get }
    var allShots: Int { get }
    func startTargetSpawn(within backgroundBoundingBox: (min: SCNVector3, max: SCNVector3))
    func addScore()
    func startCoundownTimer()
    func startTimeLeftTimer()
    func addShot()
    func saveResults()
}

final class GameViewModel: GameViewModelProtocol {
    var scorePublisher: AnyPublisher<Int, Never> {
        scoreSubject.eraseToAnyPublisher()
    }
    var timeLeftInSecondsPublisher: AnyPublisher<Double, Never> {
        timeLeftInSecondsSubject.eraseToAnyPublisher()
    }
    var countdownSecondsPublisher: AnyPublisher<Double, Never> {
        countdownSecondsSubject.eraseToAnyPublisher()
    }
    var targetPublisher: AnyPublisher<SCNNode, Never> {
        targetSubject.eraseToAnyPublisher()
    }
    var resultsPublisher: AnyPublisher<GameResults, Never> {
        resultsSubject.eraseToAnyPublisher()
    }
    private var backgroundBoundingBox: (min: SCNVector3, max: SCNVector3) = (min: SCNVector3(), max: SCNVector3())
    private(set) var allShots: Int = 0
    private lazy var timer = Timer()
    private lazy var timeLeftTimer = Timer()
    private let scoreSubject = CurrentValueSubject<Int, Never>(0)
    private let timeLeftInSecondsSubject = CurrentValueSubject<Double, Never>(Consts.timeLeft)
    private let countdownSecondsSubject = CurrentValueSubject<Double, Never>(Consts.countdownToStart)
    private let targetSubject = CurrentValueSubject<SCNNode, Never>(SCNNode())
    private var resultsSubject = PassthroughSubject<GameResults, Never>()
    
    func startCoundownTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(didUpdateCountdownTimer), userInfo: nil, repeats: true)
        AudioManager.shared.playCountdown()
    }
    
    func startTimeLeftTimer() {
        timeLeftTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didUpdateTimeLeftTimer), userInfo: nil, repeats: true)
    }
    
    func startTargetSpawn(within backgroundBoundingBox: (min: SCNVector3, max: SCNVector3)) {
        self.backgroundBoundingBox = backgroundBoundingBox
        timer = Timer.scheduledTimer(timeInterval: Consts.targetSpawnInterval, target: self, selector: #selector(didUpdateTargetSpawnTimer), userInfo: nil, repeats: true)
    }
    
    func addScore() {
        scoreSubject.value += 1
    }
    
    func addShot() {
        AudioManager.shared.playLaserShot()
        allShots += 1
    }
    
    func saveResults() {
        Storage.saveGameResults(GameResults(shots: allShots, hits: scoreSubject.value, date: Date()))
    }
    
    private func makeResults() {
        resultsSubject.send(GameResults(shots: allShots, hits: scoreSubject.value, date: Date()))
    }
}

// MARK: objc functions
private extension GameViewModel {
    @objc
    private func didUpdateCountdownTimer() {
        countdownSecondsSubject.value -= 1
        if countdownSecondsSubject.value < 0 {
            timer.invalidate()
        }
    }
    
    @objc
    private func didUpdateTimeLeftTimer() {
        if timeLeftInSecondsSubject.value <= 0.1 {
            timer.invalidate()
            timeLeftTimer.invalidate()
            timeLeftInSecondsSubject.value = 0.0
            makeResults()
        } else {
            timeLeftInSecondsSubject.value -= 0.1
        }
    }
    
    @objc
    private func didUpdateTargetSpawnTimer() {
        let randomX = Float.random(in: (backgroundBoundingBox.min.x + 1.5)..<(backgroundBoundingBox.max.x - 1.5))
        let randomY = Float.random(in: (backgroundBoundingBox.min.y + 1.5)..<(backgroundBoundingBox.max.y - 1.5))
        let randomZ = Float.random(in: (backgroundBoundingBox.min.z + 1.5)..<(backgroundBoundingBox.max.z - 1.5))
        
        let targetPosition = SCNVector3(randomX, randomY, randomZ)
        let target = SphereTarget.populateSphere(at: targetPosition)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = Consts.targetAnimationDuration
        animation.fromValue = targetPosition
        animation.toValue = SCNVector3(1, 1, 1)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        target.addAnimation(animation, forKey: nil)
        targetSubject.send(target)
        AudioManager.shared.playTargetSpawn()
    }
}
