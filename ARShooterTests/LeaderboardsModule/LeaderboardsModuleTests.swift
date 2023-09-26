@testable import ARShooter
import XCTest

final class LeaderboardsModuleTests: XCTestCase {
    func testVCCallsGameResultsCount() {
        let vm = LeaderboardsViewModelStub()
        let view = LeaderboardsViewController(viewModel: vm)
        
        _ = view.view
        
        view.view.subviews.forEach {
            if let tableView = $0 as? UITableView {
                XCTAssertEqual(tableView.numberOfRows(inSection: 0), 10)
            }
        }
    }
    
    func testVCCallsLeaderboardsCellModelFor() {
        let vm = LeaderboardsViewModelStub()
        let view = LeaderboardsViewController(viewModel: vm)
        
        _ = view.view
        
        view.view.subviews.forEach {
            if let tableView = $0 as? UITableView {
                guard
                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LeaderboardsCell,
                    let cellModel = cell.cellModel else { return }
                XCTAssertEqual(cellModel.hits, 1)
            }
        }
    }
}
