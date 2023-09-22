import SceneKit
import SpriteKit

final class VideoScreen {
    static let name = "VideoScreen"
    
    static func populate(at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let geometry = SCNPlane(width: 0.5 * 1.78, height: 0.5)
        node.geometry = geometry
        node.name = name
        node.geometry?.firstMaterial?.diffuse.contents = VideoManager.getGameplayPlayer()
        node.position = position
        return node
    }
}
