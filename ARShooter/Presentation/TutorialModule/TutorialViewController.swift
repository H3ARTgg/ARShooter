import UIKit
import ARKit
import SceneKit
import Combine

final class TutorialViewController: UIViewController {
    private var shootButton = UIButton()
    private var cancellables: Set<AnyCancellable> = []
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    private lazy var exitButton = UIButton.systemButton(with: .xMark, target: self, action: #selector(didTapExit))
    private let sceneView = ARSCNView()
    private let mainScene = SCNScene()
    private let crosshairImageView = UIImageView()
    private let viewModel: TutorialViewModelProtocol
    
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
    
    init(viewModel: TutorialViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTap(_ touch: UITapGestureRecognizer) {
        let sceneView = touch.view as! SCNView
        let touchLocation = touch.location(in: sceneView)
        guard let node = getNodeFrom(sceneView, for: touchLocation), node.name == TapMeText.name else { return }
        checkForShooting()
    }
    
    @objc
    private func didTapShoot() {
        viewModel.playShotAudio()
        let sceneView = sceneView as SCNView
        let touchLocation = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        guard let node = getNodeFrom(sceneView, for: touchLocation), node.name == SphereTarget.name else { return }
        node.removeFromParentNode()
        viewModel.getTarget()
    }
    
    @objc
    private func didTapExit() {
        dismiss(animated: true)
    }
    
    private func configureViewController() {
        setupSceneView(sceneView, with: mainScene)
        addNodes()
        setupExitButton(exitButton)
        binds()
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        viewModel.getTarget()
        viewModel.getVideoScreen()
    }
    
    private func checkForShooting() {
        if view.subviews.contains(where: { $0 == crosshairImageView }) {
            crosshairImageView.removeFromSuperview()
            shootButton.removeFromSuperview()
        } else {
            setupCrosshairImageView(crosshairImageView)
            setupShootButton(&shootButton, action: #selector(didTapShoot))
            shootButton.alpha = 1
            shootButton.isEnabled = true
        }
    }
    
    private func binds() {
        viewModel.targetSpawnPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] target in
                guard let self else { return }
                self.sceneView.scene.rootNode.addChildNode(target)
            }
            .store(in: &cancellables)
        
        viewModel.newVideoScreenPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] node in
                guard let self else { return }
                if let oldNode = self.sceneView.scene.rootNode.childNodes.first(where: { $0.name == VideoScreen.name }) {
                    oldNode.removeFromParentNode()
                    self.sceneView.scene.rootNode.addChildNode(node)
                } else {
                    self.sceneView.scene.rootNode.addChildNode(node)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: UI
private extension TutorialViewController {
    func addNodes() {
        let background = Background.makeBackgroundNode()
        let descriptionText = DescriptionText.populate(at: SCNVector3(-1, -0.5, -2))
        let tapMeText = TapMeText.populate(at: SCNVector3(-0.9, -0.6, -2))
        
        [background, descriptionText, tapMeText].forEach {
            sceneView.scene.rootNode.addChildNode($0)
        }
    }
    
    func setupExitButton(_ button: UIButton) {
        button.setTitle(nil, for: .normal)
        button.tintColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
