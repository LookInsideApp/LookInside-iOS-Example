import SwiftUI
import LookinServer

struct RootView: View {
    var body: some View {
        TabView {
            SwiftUIShowcaseView()
                .tabItem { Label("SwiftUI", systemImage: "square.stack.3d.up.fill") }
            UIKitBridgeView()
                .tabItem { Label("UIKit", systemImage: "rectangle.stack.fill") }
            StatusView()
                .tabItem { Label("Status", systemImage: "info.circle") }
        }
    }
}

private struct SwiftUIShowcaseView: View {
    @State private var counter: Int = 0
    @State private var toggle: Bool = true
    @State private var sliderValue: Double = 0.42
    @State private var pickerSelection: Int = 1
    @State private var text: String = "LookInside"

    var body: some View {
        NavigationView {
            Form {
                Section("Controls") {
                    Stepper("Counter: \(counter)", value: $counter)
                    Toggle("Toggle", isOn: $toggle)
                    Slider(value: $sliderValue)
                    TextField("Text", text: $text)
                    Picker("Picker", selection: $pickerSelection) {
                        Text("Alpha").tag(0)
                        Text("Beta").tag(1)
                        Text("Gamma").tag(2)
                    }
                }
                Section("List") {
                    ForEach(0..<5) { i in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.tint)
                            Text("Row \(i)")
                            Spacer()
                            Text("\(i * counter)")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Section("Cards") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(0..<4) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.tint.opacity(0.15))
                                .overlay(Text("Card \(i)").font(.headline))
                                .frame(height: 80)
                        }
                    }
                }
            }
            .navigationTitle("SwiftUI Showcase")
        }
        .navigationViewStyle(.stack)
    }
}

private struct UIKitBridgeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let root = LegacyTableViewController()
        return UINavigationController(rootViewController: root)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

private final class LegacyTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Hierarchy"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 12 }

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
