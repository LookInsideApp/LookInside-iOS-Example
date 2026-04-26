import SwiftUI
import LookinServer

@main
struct LookInsideExampleApp: App {
    init() {
        _ = LookInsideServer.isLicensed
        print("[LookInsideExample] launched; LookInsideServer.isLicensed=\(LookInsideServer.isLicensed)")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
