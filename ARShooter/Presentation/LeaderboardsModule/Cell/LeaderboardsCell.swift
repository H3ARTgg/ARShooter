import UIKit

final class LeaderboardsCell: UITableViewCell {
    static let identifier = "LeaderboardsCellIdentifier"
    private let rowNumberLabel = UILabel()
    private let shotsLabel = UILabel()
    private let hitsLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView(frame: .zero)
    var cellModel: LeaderboardsCellModel? {
        didSet {
            guard let cellModel else { return }
            rowNumberLabel.text = "\(cellModel.rowNumber)"
            shotsLabel.text = "\(String.totalShots): \(cellModel.shots)"
            hitsLabel.text = "\(String.totalHits): \(cellModel.hits)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateLabel.text = "\(dateFormatter.string(from: cellModel.date))"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        configureRowNumberLabel(rowNumberLabel)
        configureShotsLabel(shotsLabel)
        configureHitsLabel(hitsLabel)
        configureDateLabel(dateLabel)
        configureStackView(stackView)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension LeaderboardsCell {
    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func addSubviews() {
        contentView.addSubview(stackView)
        [rowNumberLabel, shotsLabel, hitsLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.backgroundColor = .white.withAlphaComponent(0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureRowNumberLabel(_ label: UILabel) {
        label.textColor = .white
        label.font = .semibold15
    }
    
    func configureShotsLabel(_ label: UILabel) {
        label.textColor = .white
        label.font = .semibold15
    }
    
    func configureHitsLabel(_ label: UILabel) {
        label.textColor = .white
        label.font = .semibold15
    }
    
    func configureDateLabel(_ label: UILabel) {
        label.textColor = .white
        label.font = .regular15
    }
}
