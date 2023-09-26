@testable import ARShooter
import Combine
import SceneKit

final class GameViewModelSpy: GameViewModelProtocol {
    var scorePublisher: AnyPublisher<Int, Never> = Empty().eraseToAnyPublisher()
    var timeLeftInSecondsPublisher: AnyPublisher<Double, Never> {
        timeLeftInSecondsSubject.eraseToAnyPublisher()
    }
    private let timeLeftInSecondsSubject = CurrentValueSubject<Double, Never>(60)
    var countdownSecondsPublisher: AnyPublisher<Double, Never> {
        countdownSecondsSubject.eraseToAnyPublisher()
    }
    private let countdownSecondsSubject = CurrentValueSubject<Double, Never>(3)
    var targetPublisher: AnyPublisher<SCNNode, Never> = Empty().eraseToAnyPublisher()
    var resultsPublisher: AnyPublisher<ARShooter.GameResults, Never> {
        resultsSubject.eraseToAnyPublisher()
    }
    private let resultsSubject = PassthroughSubject<ARShooter.GameResults, Never>()
    private(set) var allShots: Int = 0
    private(set) var isCountdownTimerStarted: Bool = false
    private(set) var isTimeLeftTimerStarted: Bool = false
    private(set) var isTargetSpawnStarted: Bool = false
    
    init(skipCountdown: Bool) {
        if skipCountdown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                self.countdownSecondsSubject.send(-1)
            }
        }
    }
    
    func startTargetSpawn(within backgroundBoundingBox: (min: SCNVector3, max: SCNVector3)) {
        isTargetSpawnStarted = true
    }
    
    func startCoundownTimer() {
        isCountdownTimerStarted = true
    }
    
    func startTimeLeftTimer() {
        isTimeLeftTimerStarted = true
    }
    
    func addScore() {}
    
    func addShot() {
        allShots += 1
    }
    
    func saveResults() {}
}
