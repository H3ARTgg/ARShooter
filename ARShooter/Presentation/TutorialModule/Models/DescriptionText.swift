import SceneKit

final class DescriptionText {
    static let name = "DescriptionText"
    
    static func populate(at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.name = name
        node.geometry = SCNText(string: String.description, extrusionDepth: 2.0)
        node.scale = SCNVector3(0.004, 0.005, 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        node.geometry?.materials = [material]
        node.position = position
        return node
    }
}
