import SceneKit

final class Background {
    static let name = "background"
    
    static func makeBackgroundNode() -> SCNNode {
        let boxNode = SCNNode(geometry: SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0))
        boxNode.name = name
        let imagesArray: [UIImage] = [
            .plusX,
            .minusX,
            .plusY,
            .minusY,
            .plusZ,
            .minusZ
        ]
        var materials: [SCNMaterial] = []
        imagesArray.forEach {
            let material = SCNMaterial()
            material.cullMode = .front
            material.diffuse.contents = $0
            material.blendMode = .replace
            materials.append(material)
        }
        boxNode.geometry?.materials = [materials[4], materials[1], materials[5], materials[0], materials[3], materials[2]]
        boxNode.position = SCNVector3(0,0,0)
        return boxNode
    }
}
