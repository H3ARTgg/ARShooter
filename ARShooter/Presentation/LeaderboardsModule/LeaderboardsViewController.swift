import UIKit

final class LeaderboardsViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let leaderboardsLabel = UILabel()
    private let leaderboardsTableView = UITableView(frame: .zero)
    private lazy var exitButton = UIButton.systemButton(with: .xMark, target: self, action: #selector(didTapExit))
    private let viewModel: LeaderboardsViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    init(viewModel: LeaderboardsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapExit() {
        dismiss(animated: true)
    }
    
    private func configureViewController() {
        configureBackgroundImageView(backgroundImageView)
        configureLeaderboardsLabel(leaderboardsLabel)
        configureTableView(leaderboardsTableView)
        configureExitButton(exitButton)
        addSubviews()
        addConstraints()
    }
}

// MARK: - TableView DataSource
extension LeaderboardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getGameResultsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardsCell.identifier) as? LeaderboardsCell else { return UITableViewCell() }
        cell.cellModel = viewModel.getLeaderboardsCellModelFor(indexPath)
        return cell
    }
}

// MARK: - TableView Delegate
extension LeaderboardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: - UI
private extension LeaderboardsViewController {
    func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            leaderboardsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            leaderboardsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leaderboardsTableView.topAnchor.constraint(equalTo: leaderboardsLabel.bottomAnchor, constant: 40),
            leaderboardsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            leaderboardsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            leaderboardsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            exitButton.centerYAnchor.constraint(equalTo: leaderboardsLabel.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.widthAnchor.constraint(equalToConstant: 40),
            exitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func addSubviews() {
        [backgroundImageView, leaderboardsLabel, leaderboardsTableView, exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func configureBackgroundImageView(_ imageView: UIImageView) {
        backgroundImageView.image = .menuBackground
    }
    
    func configureLeaderboardsLabel(_ label: UILabel) {
        label.text = .leaderboards
        label.font = .bold50
        label.textColor = .white
    }
    
    func configureTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LeaderboardsCell.self, forCellReuseIdentifier: LeaderboardsCell.identifier)
        tableView.backgroundColor = .black.withAlphaComponent(0.4)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    func configureExitButton(_ button: UIButton) {
        button.tintColor = .white
        button.setTitle(nil, for: .normal)
    }
}
