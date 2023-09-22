import SceneKit

final class DescriptionText {
    static let name = "DescriptionText"
    
    static func populate(at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let string = """
        The rules are simple!
        Shoot as many spheres as you can before you run out of time.
        Remember - they can be anywhere (even behind you).
        To try this out - find button to enable shooting mode in here
        and test your aim on sphere in this room. Good luck!
        """
        node.name = name
        node.geometry = SCNText(string: string, extrusionDepth: 2.0)
        node.scale = SCNVector3(0.004, 0.005, 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        node.geometry?.materials = [material]
        node.position = position
        return node
    }
}
