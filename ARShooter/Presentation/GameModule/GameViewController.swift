import UIKit
import SceneKit
import ARKit
import Combine

final class GameViewController: UIViewController {
    private let sceneView = ARSCNView()
    private let mainScene = SCNScene()
    private let countdownLabel = UILabel()
    private let crosshairImageView = UIImageView()
    private let timeLeftLabel = UILabel()
    private let timeLeftSecondsLabel = UILabel()
    private let scoreLabel = UILabel()
    private lazy var shootButton: UIButton = {
        let button = UIButton.systemButton(with: .shoot.withRenderingMode(.alwaysOriginal), target: self, action: #selector(didTapShoot))
        return button
    }()
    private var cancellables: Set<AnyCancellable> = []
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
        setupCountdownLabel(countdownLabel)
        viewModel.startCoundownTimer()
    }
    
    init(viewModel: GameViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapShoot() {
        viewModel.addShot()
        let sceneView = sceneView as SCNView
        let touchLocation = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        if let node = getNodeFrom(sceneView, for: touchLocation) {
            viewModel.addScore()
            node.removeFromParentNode()
        }
    }
    
    @objc
    private func didTap(_ touch: UITapGestureRecognizer) {
        viewModel.addShot()
        let sceneView = touch.view as! SCNView
        let touchLocation = touch.location(in: sceneView)
        if let node = getNodeFrom(sceneView, for: touchLocation) {
            viewModel.addScore()
            node.removeFromParentNode()
        }
    }
    
    private func getNodeFrom(_ sceneView: SCNView, for location: CGPoint) -> SCNNode? {
        let touchResult = sceneView.hitTest(location)
        guard !touchResult.isEmpty, let node = touchResult.first?.node, node.name == SphereTarget.name else { return nil }
        return node
    }
    
    private func configureViewController() {
        setupSceneView(sceneView, with: mainScene)
        let backgroundSphereNode = Background.makeBackgroundNode()
        sceneView.scene.rootNode.addChildNode(backgroundSphereNode)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        binds()
    }
    
    private func setupAfterCountdown() {
        countdownLabel.removeFromSuperview()
        setupCrosshairImageView(crosshairImageView)
        setupShootButton(shootButton)
        setupTimeLeftLabel(timeLeftLabel)
        setupTimeLeftSecondsLabel(timeLeftSecondsLabel)
        setupScoreLabel(scoreLabel)
        viewModel.startTimeLeftTimer()
        for node in sceneView.scene.rootNode.childNodes {
            if node.name == Background.name {
                viewModel.startTargetSpawn(within: node.boundingBox)
            }
        }
    }
    
    private func binds() {
        viewModel.scorePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] score in
                self?.scoreLabel.text = "\(String.score): \(score)"
            }
            .store(in: &cancellables)
        
        viewModel.timeLeftInSecondsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] seconds in
                let numberFormatter = NumberFormatter()
                numberFormatter.decimalSeparator = "."
                numberFormatter.maximumFractionDigits = 1
                numberFormatter.roundingMode = .down
                self?.timeLeftSecondsLabel.text = "\(numberFormatter.string(from: NSNumber(value: seconds)) ?? "error") \(String.seconds)"
                if seconds <= 10 {
                    self?.timeLeftSecondsLabel.textColor = .red
                }
            }
            .store(in: &cancellables)
        
        viewModel.countdownSecondsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] seconds in
                if seconds < 0 {
                    self?.setupAfterCountdown()
                } else {
                    self?.countdownLabel.text = "\(Int(seconds))"
                }
            }
            .store(in: &cancellables)
        
        viewModel.targetPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] target in
                self?.sceneView.scene.rootNode.addChildNode(target)
            }
            .store(in: &cancellables)
        
        viewModel.resultsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.setupAlertWith(results)
            }
            .store(in: &cancellables)
    }
    
    private func moveToMenuWithSave(_ check: Bool) {
        if check {
            viewModel.saveResults()
        }
        dismiss(animated: true)
    }
}

// MARK: - UI
private extension GameViewController {
    func setupSceneView(_ sceneView: ARSCNView, with scene: SCNScene) {
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
    
    func setupCountdownLabel(_ label: UILabel) {
        label.text = "3"
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
    
    func setupShootButton(_ button: UIButton) {
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupTimeLeftLabel(_ label: UILabel) {
        label.text = "\(String.timeLeft): "
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
    
    func setupTimeLeftSecondsLabel(_ label: UILabel) {
        label.text = "60.0 \(String.seconds)"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: timeLeftLabel.trailingAnchor)
        ])
    }
    
    func setupScoreLabel(_ label: UILabel) {
        label.text = "\(String.score): 0"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func setupAlertWith(_ results: GameResults) {
        let message = "\(String.totalShots): \(results.shots); \(String.totalHits): \(results.hits)"
        let alert = UIAlertController(title: .gameOver, message: message, preferredStyle: .alert)
        alert.view.tintColor = .green
        let backToMenuAction = UIAlertAction(title: .backToMenu, style: .default) { [weak self] _ in
            self?.moveToMenuWithSave(false)
        }
        let saveToLeaderboardsAction = UIAlertAction(title: .saveToLeaderboards, style: .default) { [weak self] _ in
            self?.moveToMenuWithSave(true)
        }
        alert.addAction(backToMenuAction)
        alert.addAction(saveToLeaderboardsAction)
        present(alert, animated: true)
    }
}
