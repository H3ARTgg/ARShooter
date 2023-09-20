import UIKit
import SceneKit
import ARKit

final class GameViewController: UIViewController {
    private let sceneView = ARSCNView()
    private let mainScene = SCNScene()
    private let counterLabel = UILabel()
    private let crosshairImageView = UIImageView()
    private let viewModel: GameViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCounterLabel(counterLabel)
    }
    
    init(viewModel: GameViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewController() {
        setupSceneView(sceneView, with: mainScene)
        addNodesTo(mainScene)
    }
    
    private func addNodesTo(_ scene: SCNScene) {
        let backgroundSphereNode = Background.makeBackgroundNode()
        scene.rootNode.addChildNode(backgroundSphereNode)
    }
    
    private func setupSceneView(_ sceneView: ARSCNView, with scene: SCNScene) {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = scene
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UI
private extension GameViewController {
    func setupCounterLabel(_ label: UILabel) {
        label.text = "3"
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            label.text = "2"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                label.text = "1"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    label.text = "0"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        label.removeFromSuperview()
                        self.setupCrosshairImageView(self.crosshairImageView)
                    }
                }
            }
        }
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

// MARK: - ARSCNViewDelegate
extension GameViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
