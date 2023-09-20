import Foundation

enum LocaleKeys: String {
    case play = "play"
    case leaderboards = "leaderboards"
    case backToMenu = "back_to_menu"
    case saveToLeaderboards = "save_to_leaderboards"
    case timeLeft = "time_left"
    case gameOver = "game_over"
    case score = "score"
    case seconds = "seconds"
    case totalShots = "totalShots"
    case totalHits = "totalHits"
}

extension String {
    static let play = NSLocalizedString(LocaleKeys.play.rawValue, comment: "")
    static let leaderboards = NSLocalizedString(LocaleKeys.leaderboards.rawValue, comment: "")
    static let backToMenu = NSLocalizedString(LocaleKeys.backToMenu.rawValue, comment: "")
    static let saveToLeaderboards = NSLocalizedString(LocaleKeys.saveToLeaderboards.rawValue, comment: "")
    static let timeLeft = NSLocalizedString(LocaleKeys.timeLeft.rawValue, comment: "")
    static let gameOver = NSLocalizedString(LocaleKeys.gameOver.rawValue, comment: "")
    static let score = NSLocalizedString(LocaleKeys.score.rawValue, comment: "")
    static let seconds = NSLocalizedString(LocaleKeys.seconds.rawValue, comment: "")
    static let totalShots = NSLocalizedString(LocaleKeys.totalShots.rawValue, comment: "")
    static let totalHits = NSLocalizedString(LocaleKeys.totalHits.rawValue, comment: "")
}
