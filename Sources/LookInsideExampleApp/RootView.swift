import LookinServer
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            SwiftUIDemoView()
                .tabItem { Label("SwiftUI", systemImage: "square.stack.3d.up.fill") }
            UIKitBridgeView()
                .tabItem { Label("UIKit", systemImage: "rectangle.stack.fill") }
            StatusView()
                .tabItem { Label("Status", systemImage: "info.circle") }
        }
    }
}

private struct UIKitBridgeView: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UINavigationController {
        let root = LegacyTableViewController()
        return UINavigationController(rootViewController: root)
    }

    func updateUIViewController(_: UINavigationController, context _: Context) {}
}

private final class LegacyTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Hierarchy"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        12
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "Row \(indexPath.row)"
        config.secondaryText = "UIKit cell"
        config.image = UIImage(systemName: "doc.text")
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

private struct StatusView: View {
    @State private var isLicensed: Bool = LookInsideServer.isLicensed

    var body: some View {
        NavigationView {
            List {
                Section("LookInsideServer") {
                    LabeledContent("isLicensed", value: isLicensed ? "YES" : "NO")
                    Button("Refresh") { isLicensed = LookInsideServer.isLicensed }
                }
                Section("How to use") {
                    Text("1. Run this app on the iOS Simulator.")
                    Text("2. Launch the LookInside macOS host on the same Mac.")
                    Text("3. The host should auto-discover this app via Peertalk on ports 47164–47169 (sim) / 47175–47179 (USB).")
                }
            }
            .navigationTitle("Status")
            .onReceive(NotificationCenter.default.publisher(for: .LookInsideServerLicenseStateDidChange)) { _ in
                isLicensed = LookInsideServer.isLicensed
            }
        }
        .navigationViewStyle(.stack)
    }
}

private extension Notification.Name {
    static let LookInsideServerLicenseStateDidChange = Notification.Name("LookInsideServerLicenseStateDidChangeNotification")
}
