import Foundation

final class Storage {
    static let gameResultsKey = "gameResults"
    static var gameResults: [GameResults]? {
        get {
            guard let results = UserDefaults.standard.codableObject(dataType: [GameResults].self, key: gameResultsKey) else { return nil}
            return results
        }
    }
    
    static func saveGameResults(_ gameResults: GameResults) {
        var results = UserDefaults.standard.codableObject(dataType: [GameResults].self, key: gameResultsKey)
        if results == nil {
            UserDefaults.standard.setCodableObject([gameResults], forKey: gameResultsKey)
        } else {
            results?.append(gameResults)
            UserDefaults.standard.setCodableObject(results, forKey: gameResultsKey)
        }
    }
}
