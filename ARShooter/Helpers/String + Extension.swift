import Foundation

enum LocaleKeys: String {
    case play = "play"
    case statistics = "statistics"
}

extension String {
    static let play = NSLocalizedString(LocaleKeys.play.rawValue, comment: "")
    static let statistics = NSLocalizedString(LocaleKeys.statistics.rawValue, comment: "")
}
