import UIKit

final class MenuViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let gameNameLabel = UILabel()
    private lazy var playButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapPlayButton))
        return button
    }()
    private lazy var statisticsButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapStatisticsButton))
        return button
    }()
    
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
    private func didTapStatisticsButton() {
        
    }
    
    private func configureViewController() {
        view.backgroundColor = .brown
        configureBackgroundImageView(backgroundImageView)
        configureGameNameLabel(gameNameLabel)
        configurePlayButton(playButton)
        configureStatisticsButton(statisticsButton)
        addSubviews()
        addConstraints()
    }
}

// MARK: - UI
private extension MenuViewController {
    func addSubviews() {
        [backgroundImageView, gameNameLabel, playButton, statisticsButton].forEach {
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
            
            statisticsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            statisticsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            statisticsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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
    
    func configureStatisticsButton(_ button: UIButton) {
        button.setImage(nil, for: .normal)
        button.setTitle(.statistics, for: .normal)
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
    }
}
