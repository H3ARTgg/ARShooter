import SceneKit

final class Background {
    static func makeBackgroundNode() -> SCNNode {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 10))
        let material = SCNMaterial()
        sphereNode.name = "background"
        material.cullMode = .front
        material.diffuse.contents = UIImage.background
        sphereNode.geometry?.materials = [material]
        sphereNode.position = SCNVector3(0, 0, 0)
        return sphereNode
    }
}
