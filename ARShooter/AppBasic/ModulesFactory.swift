final class ModulesFactory {
    static func makeMenuModule() -> Presentable {
        MenuViewController()
    }
    
    static func makeGameModule() -> Presentable {
        let vm = GameViewModel()
        let vc = GameViewController(viewModel: vm)
        return vc
    }
    
    static func makeLeaderboardsModule() -> Presentable {
        let vm = LeaderboardsViewModel()
        let vc = LeaderboardsViewController(viewModel: vm)
        return vc
    }
}
