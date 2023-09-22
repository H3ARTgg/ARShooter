import UIKit
import ARKit
import SceneKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
    
    func getNodeFrom(_ sceneView: SCNView, for location: CGPoint) -> SCNNode? {
        let touchResult = sceneView.hitTest(location)
        guard !touchResult.isEmpty, let node = touchResult.first?.node else { return nil }
        return node
    }
    
    func setupSceneView(_ sceneView: ARSCNView, with scene: SCNScene) {
        sceneView.showsStatistics = false
        sceneView.scene = scene
        sceneView.scene.rootNode.flattenedClone()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupShootButton(_ button: inout UIButton, action selector: Selector) {
        button = UIButton.systemButton(with: .shoot.withRenderingMode(.alwaysOriginal), target: self, action: selector)
        button.setTitle(nil, for: .normal)
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupCrosshairImageView(_ imageView: UIImageView) {
        imageView.image = .crosshair
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
