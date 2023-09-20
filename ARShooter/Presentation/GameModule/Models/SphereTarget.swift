import SceneKit

final class SphereTarget {
    static let name = "target"
    
    static func populateSphere(at position: SCNVector3) -> SCNNode {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.2))
        sphereNode.name = name
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = UIImage.sphereTexture
        sphereNode.geometry?.materials = [material]
        sphereNode.position = position
        return sphereNode
    }
}
