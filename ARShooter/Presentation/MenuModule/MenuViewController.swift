import UIKit

final class MenuViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let gameNameLabel = UILabel()
    private lazy var playButton = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapPlayButton))
    private lazy var leaderboardsButton = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapLeaderboardsButton))
    private lazy var tutorialButton = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapTutorial))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    @objc
    private func didTapPlayButton() {
        guard let gameVC = ModulesFactory.makeGameModule().toPresent() else { return }
        present(gameVC, animated: true)
    }
    
    @objc
    private func didTapLeaderboardsButton() {
        guard let leaderboardsVC = ModulesFactory.makeLeaderboardsModule().toPresent() else { return }
        present(leaderboardsVC, animated: true)
    }
    
    @objc
    private func didTapTutorial() {
        guard let tutorialVC = ModulesFactory.makeTutorialModule().toPresent() else { return }
        present(tutorialVC, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .brown
        configureBackgroundImageView(backgroundImageView)
        configureGameNameLabel(gameNameLabel)
        configurePlayButton(playButton)
        configureLeaderboardsButton(leaderboardsButton)
        configureTutorialButton(tutorialButton)
        
        addSubviews()
        addConstraints()
    }
}

// MARK: - UI
private extension MenuViewController {
    func addSubviews() {
        [backgroundImageView, gameNameLabel, playButton, leaderboardsButton, tutorialButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gameNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            gameNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            gameNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            playButton.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 40),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            tutorialButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            tutorialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            tutorialButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            leaderboardsButton.topAnchor.constraint(equalTo: tutorialButton.bottomAnchor, constant: 20),
            leaderboardsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            leaderboardsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    func configureBackgroundImageView(_ imageView: UIImageView) {
        imageView.image = .menuBackground
    }
    
    func configureGameNameLabel(_ label: UILabel) {
        label.text = "ARShooter"
        label.textColor = .green
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50, weight: .bold)
    }
    
    func configurePlayButton(_ button: UIButton) {
        button.setImage(nil, for: .normal)
        button.setTitle(.play, for: .normal)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    func configureLeaderboardsButton(_ button: UIButton) {
        button.setImage(nil, for: .normal)
        button.setTitle(.leaderboards, for: .normal)
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    func configureTutorialButton(_ button: UIButton) {
        button.setImage(nil, for: .normal)
        button.setTitle("Tutorial", for: .normal)
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
    }
}
