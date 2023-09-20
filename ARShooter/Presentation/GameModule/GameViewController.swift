import UIKit
import SceneKit
import ARKit

final class GameViewController: UIViewController {
    private let sceneView = ARSCNView()
    private let mainScene = SCNScene()
    private let countdownLabel = UILabel()
    private lazy var countdownTimer = Timer()
    private var countdownSeconds = 3
    private let crosshairImageView = UIImageView()
    private let timeLeftLabel = UILabel()
    private let timeLeftSecondsLabel = UILabel()
    private var timeLeftInSeconds: Float = 60
    private lazy var timeLeftTimer = Timer()
    private let scoreLabel = UILabel()
    private lazy var shootButton: UIButton = {
        let button = UIButton.systemButton(with: .shoot.withRenderingMode(.alwaysOriginal), target: self, action: #selector(didTapShoot))
        return button
    }()
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
        runCountdownTimer(&countdownTimer)
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
        let sceneView = sceneView as SCNView
        let touchLocation = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let touchResult = sceneView.hitTest(touchLocation)
        guard !touchResult.isEmpty, let node = touchResult.first?.node, node.name != "background" else { return }
        node.removeFromParentNode()
    }
    
    @objc
    private func didUpdateCountdownTimer() {
        countdownSeconds -= 1
        if countdownSeconds <= -1 {
            countdownTimer.invalidate()
            setupAfterCountdown()
            return
        }
        countdownLabel.text = "\(countdownSeconds)"
    }
    
    @objc
    private func didUpdateTimeLeftTimer() {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.roundingMode = .down
        timeLeftInSeconds -= 0.1
        if timeLeftInSeconds <= -0.1 {
            timeLeftLabel.removeFromSuperview()
            timeLeftSecondsLabel.removeFromSuperview()
            timeLeftTimer.invalidate()
            return
        }
        timeLeftSecondsLabel.text = numberFormatter.string(from: NSNumber(value: timeLeftInSeconds)) ?? "error"
    }
    
    private func runCountdownTimer(_ timer: inout Timer) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(didUpdateCountdownTimer), userInfo: nil, repeats: true)
    }
    
    private func runTimeLeftTimer(_ timer: inout Timer) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didUpdateTimeLeftTimer), userInfo: nil, repeats: true)
    }
    
    private func configureViewController() {
        setupSceneView(sceneView, with: mainScene)
        let backgroundSphereNode = Background.makeBackgroundNode()
        sceneView.scene.rootNode.addChildNode(backgroundSphereNode)
    }
    
    private func setupAfterCountdown() {
        countdownLabel.removeFromSuperview()
        setupCrosshairImageView(self.crosshairImageView)
        setupShootButton(self.shootButton)
        setupTimeLeftLabel(timeLeftLabel)
        setupTimeLeftSecondsLabel(timeLeftSecondsLabel)
        runTimeLeftTimer(&timeLeftTimer)
        setupScoreLabel(scoreLabel)
    }
}

// MARK: - UI
private extension GameViewController {
    func setupSceneView(_ sceneView: ARSCNView, with scene: SCNScene) {
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
        label.text = "Time left: "
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
    
    func setupTimeLeftSecondsLabel(_ label: UILabel) {
        label.text = "60.0"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: timeLeftLabel.trailingAnchor)
        ])
    }
    
    func setupScoreLabel(_ label: UILabel) {
        label.text = "Score: 0"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
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
