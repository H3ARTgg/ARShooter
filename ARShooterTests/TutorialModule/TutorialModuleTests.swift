@testable import ARShooter
import XCTest
import SceneKit

final class TutorialModuleTests: XCTestCase {
    func testVCCallsGetTarget() {
        let vm = TutorialViewModuleSpy()
        let view = TutorialViewController(viewModel: vm)
        
        _ = view.view
        
        XCTAssertTrue(vm.isTargetRequested)
    }
    
    func testVCCallsGetVideoScreen() {
        let vm = TutorialViewModuleSpy()
        let view = TutorialViewController(viewModel: vm)
        
        _ = view.view
        
        XCTAssertTrue(vm.isVideoScreenRequested)
    }
}
