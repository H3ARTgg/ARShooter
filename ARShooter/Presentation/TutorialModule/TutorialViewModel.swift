import SceneKit
import Combine

protocol TutorialViewModelProtocol {
    var targetSpawnPublisher: AnyPublisher<SCNNode, Never> { get }
    var newVideoScreenPublisher: AnyPublisher<SCNNode, Never> { get }
    func getTarget()
    func getVideoScreen()
    func playShotAudio()
}

final class TutorialViewModel: TutorialViewModelProtocol {
    var targetSpawnPublisher: AnyPublisher<SCNNode, Never> {
        targetSpawnSubject.eraseToAnyPublisher()
    }
    var newVideoScreenPublisher: AnyPublisher<SCNNode, Never> {
        newVideoScreenSubject.eraseToAnyPublisher()
    }
    private var loopScreenTimer = Timer()
    private let targetSpawnSubject = PassthroughSubject<SCNNode, Never>()
    private let newVideoScreenSubject = PassthroughSubject<SCNNode, Never>()
    
    func playShotAudio() {
        AudioManager.shared.playLaserShot()
    }
    
    func getTarget() {
        let randomY = Float.random(in: -0.8...0)
        let position = SCNVector3(-1.2, randomY, -2)
        let target = SphereTarget.populateSphere(at: position)
        target.addAnimation(getRotatingAnimation(), forKey: "")
        target.filters = getBloom()
        targetSpawnSubject.send(target)
    }
    
    func getVideoScreen() {
        loopScreenTimer = Timer.scheduledTimer(timeInterval: 14, target: self, selector: #selector(didUpdateTimer), userInfo: nil, repeats: true)
        let screen = VideoScreen.populate(at: SCNVector3(0.95, -0.3, -2))
        newVideoScreenSubject.send(screen)
    }
    
    @objc
    private func didUpdateTimer() {
        let screen = VideoScreen.populate(at: SCNVector3(1, -0.3, -2))
        newVideoScreenSubject.send(screen)
    }
    
    private func getBloom() -> [CIFilter]? {
        let bloomFilter = CIFilter(name:"CIBloom")!
        bloomFilter.setValue(5.0, forKey: "inputIntensity")
        bloomFilter.setValue(20.0, forKey: "inputRadius")
        return [bloomFilter]
    }
    
    private func getRotatingAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 5
        animation.fromValue = SCNVector4(0, 0, 0, 0)
        animation.toValue = SCNVector4(0, 0, 1, CGFloat(2 * Double.pi))
        animation.repeatCount = .infinity
        return animation
    }
}
