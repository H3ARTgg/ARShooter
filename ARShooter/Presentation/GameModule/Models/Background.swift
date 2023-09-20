import SceneKit

final class Background {
    static let name = "background"
    
    static func makeBackgroundNode() -> SCNNode {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: Consts.backgroundRadius))
        let material = SCNMaterial()
        sphereNode.name = name
        material.cullMode = .front
        material.diffuse.contents = UIImage.background
        sphereNode.geometry?.materials = [material]
        sphereNode.position = SCNVector3(0, 0, 0)
        return sphereNode
    }
}
