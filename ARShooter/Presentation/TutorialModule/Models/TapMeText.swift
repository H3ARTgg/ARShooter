import SceneKit

final class TapMeText {
    static let name = "TapMeText"
    
    static func populate(at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.name = name
        node.geometry = SCNText(string: "TAP ME", extrusionDepth: 2.0)
        node.scale = SCNVector3(0.007, 0.007, 0.007)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        node.geometry?.materials = [material]
        node.position = position
        return node
    }
}
