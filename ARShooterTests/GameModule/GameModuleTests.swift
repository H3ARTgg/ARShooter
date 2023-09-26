@testable import ARShooter
import XCTest

final class GameModuleTests: XCTestCase {
    func testVCCallsCountdown() throws {
        let vm = GameViewModelSpy(skipCountdown: false)
        let view = GameViewController(viewModel: vm)
        
        let expectation = expectation(description: "Countdown expectation")
        view.beginAppearanceTransition(true, animated: true)
        view.endAppearanceTransition()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(vm.isCountdownTimerStarted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testVCCallsStartTimeLeftTimerAndTargetSpawn() {
        let vm = GameViewModelSpy(skipCountdown: true)
        let view = GameViewController(viewModel: vm)
        
        let expectation = expectation(description: "Timer and TargetSpawn expectations")
        _ = view.view
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(vm.isTimeLeftTimerStarted)
            XCTAssertTrue(vm.isTargetSpawnStarted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5)
    }
    
    func testVCCallsAddShot() {
        let vm = GameViewModelSpy(skipCountdown: true)
        let view = GameViewController(viewModel: vm)
        
        let expectation = expectation(description: "Timer and TargetSpawn expectations")
        _ = view.view
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.view.subviews.forEach {
                if let button = $0 as? UIButton {
                    button.sendActions(for: .touchUpInside)
                    button.sendActions(for: .touchUpInside)
                }
            }
            XCTAssertEqual(vm.allShots, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5)
    }
}
