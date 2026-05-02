import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MusicPlayerView()
                .tabItem { Label("Music", systemImage: "play.circle.fill") }

            SocialFeedView()
                .tabItem { Label("Feed", systemImage: "square.text.square.fill") }

            ChatView()
                .tabItem { Label("Chat", systemImage: "bubble.left.and.bubble.right.fill") }

            StatusView()
                .tabItem { Label("Status", systemImage: "info.circle") }
        }
    }
}

private struct StatusView: View {
    @State private var isLicensed: Bool = LookInsideServerRuntime.isLicensed

    var body: some View {
        NavigationStack {
            List {
                Section("LookInsideServer") {
                    LabeledContent("isLicensed", value: isLicensed ? "YES" : "NO")
                    Button("Refresh") { isLicensed = LookInsideServerRuntime.isLicensed }
                }
                Section("Demos") {
                    Label("Music player", systemImage: "play.circle")
                    Label("Social feed", systemImage: "square.text.square")
                    Label("Chat", systemImage: "bubble.left.and.bubble.right")
                }
                Section("How to use") {
                    Text("1. Run this app on the iOS Simulator (or Mac via Catalyst).")
                    Text("2. Launch the LookInside macOS host on the same Mac.")
                    Text("3. The host should auto-discover this app via Peertalk on ports 47164–47169 (sim) / 47175–47179 (USB).")
                }
            }
            .navigationTitle("Status")
            .onReceive(NotificationCenter.default.publisher(for: .LookInsideServerLicenseStateDidChange)) { _ in
                isLicensed = LookInsideServerRuntime.isLicensed
            }
        }
    }
}

private extension Notification.Name {
    static let LookInsideServerLicenseStateDidChange = Notification.Name("LookInsideServerLicenseStateDidChangeNotification")
}
