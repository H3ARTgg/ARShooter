import Foundation

protocol LeaderboardsViewModelProtocol {
    func getLeaderboardsCellModelFor(_ indexPath: IndexPath) -> LeaderboardsCellModel
    func getGameResultsCount() -> Int
}

final class LeaderboardsViewModel: LeaderboardsViewModelProtocol {
    private var gameResults: [GameResults] = []
    
    init() {
        guard let results = Storage.gameResults else { return }
        self.gameResults = results
    }
    
    func getLeaderboardsCellModelFor(_ indexPath: IndexPath) -> LeaderboardsCellModel {
        convert(gameResults[indexPath.row], for: indexPath)
    }
    
    func getGameResultsCount() -> Int {
        gameResults.count
    }
    
    private func convert(_ gameResults: GameResults, for indexPath: IndexPath) -> LeaderboardsCellModel {
        LeaderboardsCellModel(
            rowNumber: indexPath.row + 1,
            shots: gameResults.shots,
            hits: gameResults.hits,
            date: gameResults.date
        )
    }
}
