import SwiftUI

@main
struct LookInsideExampleApp: App {
    init() {
        print("[LookInsideExample] launched; LookInsideServer.isLicensed=\(LookInsideServerRuntime.isLicensed)")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
