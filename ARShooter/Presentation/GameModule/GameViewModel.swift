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
    private let resultsSubject = PassthroughSubject<GameResults, Never>()
    
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
    
    private func getRandomSCNVector3(with boundingBox: (min: SCNVector3, max: SCNVector3)) -> SCNVector3 {
        let randomX = Float.random(in: (backgroundBoundingBox.min.x + 1.5)..<(backgroundBoundingBox.max.x - 1.5))
        let randomY = Float.random(in: (backgroundBoundingBox.min.y + 1.5)..<(backgroundBoundingBox.max.y - 1.5))
        let randomZ = Float.random(in: (backgroundBoundingBox.min.z + 1.5)..<(backgroundBoundingBox.max.z - 1.5))
        return SCNVector3(randomX, randomY, randomZ)
    }
}

// MARK: objc functions
private extension GameViewModel {
    @objc
    func didUpdateCountdownTimer() {
        countdownSecondsSubject.value -= 1
        if countdownSecondsSubject.value < 0 {
            timer.invalidate()
        }
    }
    
    @objc
    func didUpdateTimeLeftTimer() {
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
    func didUpdateTargetSpawnTimer() {
        let randomStartPosition = getRandomSCNVector3(with: backgroundBoundingBox)
        let randomEndPosition = getRandomSCNVector3(with: backgroundBoundingBox)
        let target = SphereTarget.populateSphere(at: randomStartPosition)
        target.addAnimation(getMovingAnimationFrom(randomStartPosition, to: randomEndPosition), forKey: nil)
        target.addAnimation(getRotatingAnimation(), forKey: nil)
        target.filters = getBloom()
        targetSubject.send(target)
        AudioManager.shared.playTargetSpawn()
    }
}

// MARK: - Animations & Effects
private extension GameViewModel {
    func getMovingAnimationFrom(_ position: SCNVector3, to endPosition: SCNVector3) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = Consts.targetAnimationDuration
        animation.fromValue = position
        animation.toValue = endPosition
        animation.autoreverses = true
        animation.repeatCount = .infinity
        return animation
    }
    
    func getRotatingAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 5
        animation.fromValue = SCNVector4(0, 0, 0, 0)
        animation.toValue = SCNVector4(0, 0, 1, CGFloat(2 * Double.pi))
        animation.repeatCount = .infinity
        return animation
    }
    
    private func getBloom() -> [CIFilter]? {
        let bloomFilter = CIFilter(name:"CIBloom")!
        bloomFilter.setValue(5.0, forKey: "inputIntensity")
        bloomFilter.setValue(20.0, forKey: "inputRadius")
        return [bloomFilter]
    }
}
