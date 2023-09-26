@testable import ARShooter
import Combine
import SceneKit

final class TutorialViewModuleSpy: TutorialViewModelProtocol {
    var targetSpawnPublisher: AnyPublisher<SCNNode, Never> = Empty().eraseToAnyPublisher()
    var newVideoScreenPublisher: AnyPublisher<SCNNode, Never> = Empty().eraseToAnyPublisher()
    private(set) var isTargetRequested = false
    private(set) var isVideoScreenRequested = false
    private(set) var isShotAudioRequested = false
    
    func getTarget() {
        isTargetRequested = true
    }
    
    func getVideoScreen() {
        isVideoScreenRequested = true
    }
    
    func playShotAudio() {}
}
