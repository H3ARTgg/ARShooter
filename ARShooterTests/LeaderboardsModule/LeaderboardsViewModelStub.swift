@testable import ARShooter
import Foundation

final class LeaderboardsViewModelStub: LeaderboardsViewModelProtocol {
    func getLeaderboardsCellModelFor(_ indexPath: IndexPath) -> ARShooter.LeaderboardsCellModel {
        ARShooter.LeaderboardsCellModel(rowNumber: 0, shots: 1, hits: 1, date: Date())
    }
    
    func getGameResultsCount() -> Int {
        10
    }
}
