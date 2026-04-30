import SwiftUI

@main
struct LookInsideExampleApp: App {
    init() {
        _ = LookInsideServerRuntime.isLicensed
        print("[LookInsideExample] launched; LookInsideServer.isLicensed=\(LookInsideServerRuntime.isLicensed)")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
