import SwiftUI

struct SwiftUIDemoView: View {
    @Namespace private var namespace
    @State private var selectedMetricID = DemoMetric.samples[0].id
    @State private var selectedMode: DemoMode = .inspect
    @State private var selectedPalette = 0
    @State private var note = "Inspect this text field"
    @State private var isExpanded = true
    @State private var isShowingDetail = false
    @State private var progress = 0.62

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    hero
                    metricGrid
                    transformLab
                    controlPanel
                    timeline
                    disclosureFixture
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("SwiftUI Fixture")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Palette", selection: $selectedPalette) {
                            ForEach(Array(DemoPalette.samples.enumerated()), id: \.offset) { index, palette in
                                Text(palette.name).tag(index)
                            }
                        }
                    } label: {
                        Image(systemName: "paintpalette")
                    }
                }
            }
            .sheet(isPresented: $isShowingDetail) {
                DetailSheet(metric: selectedMetric)
            }
        }
    }

    private var selectedMetric: DemoMetric {
        DemoMetric.samples.first { $0.id == selectedMetricID } ?? DemoMetric.samples[0]
    }

    private var palette: DemoPalette {
        DemoPalette.samples[selectedPalette]
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("LookInside SwiftUI")
                        .font(.title2.weight(.bold))
                    Text("Nested stacks, overlays, transforms, lazy grids, forms, transitions, and menus in one surface.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(palette.primary.opacity(0.2))
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.title2)
                        .foregroundStyle(palette.primary)
                }
                .frame(width: 54, height: 54)
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(palette.accent)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(.background, lineWidth: 2))
                }
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.white.opacity(0.45))
                    .frame(height: 12)
                Capsule()
                    .fill(LinearGradient(colors: [palette.primary, palette.accent], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(40, 280 * progress), height: 12)
                    .animation(.easeInOut(duration: 0.25), value: progress)
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    HeroPill(title: "Protocol", value: "8", color: palette.primary)
                    HeroPill(title: "Readable", value: "1.3.0", color: palette.accent)
                    HeroPill(title: "SwiftUI", value: "Fixture", color: .purple)
                }
                VStack(alignment: .leading, spacing: 10) {
                    HeroPill(title: "Protocol", value: "8", color: palette.primary)
                    HeroPill(title: "Readable", value: "1.3.0", color: palette.accent)
                    HeroPill(title: "SwiftUI", value: "Fixture", color: .purple)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(colors: [palette.primary.opacity(0.24), palette.accent.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.35), lineWidth: 1)
        }
    }

    private var metricGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(DemoMetric.samples) { metric in
                MetricCard(
                    metric: metric,
                    isSelected: selectedMetricID == metric.id,
                    namespace: namespace,
                    color: metric.color
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                        selectedMetricID = metric.id
                        progress = metric.progress
                    }
                }
            }
        }
    }

    private var transformLab: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Transform Lab", subtitle: "Offsets, affine transforms, rotation, masks")

            HStack(spacing: 14) {
                TransformTile(title: "Offset", color: .cyan)
                    .offset(x: 10, y: -6)

                TransformTile(title: "Rotate", color: .orange)
                    .rotationEffect(.degrees(selectedMode.rotationDegrees))
                    .scaleEffect(selectedMode.scale)

                TransformTile(title: "Affine", color: .mint)
                    .transformEffect(
                        CGAffineTransform(translationX: 8, y: 0)
                            .scaledBy(x: 0.92, y: 1.08)
                    )
            }

            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
                    .frame(height: 96)
                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(palette.primary.opacity(0.22 + Double(index) * 0.11))
                            .frame(width: CGFloat(24 + index * 6), height: CGFloat(24 + index * 6))
                            .overlay {
                                Circle().stroke(palette.primary.opacity(0.35), lineWidth: 1)
                            }
                    }
                }
            }
            .mask(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(16)
        .background(CardBackground())
    }

    private var controlPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Controls", subtitle: "State mutations for live refresh")

            Picker("Mode", selection: $selectedMode) {
                ForEach(DemoMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 8) {
                Slider(value: $progress, in: 0.1...1.0)
                Gauge(value: progress) {
                    Text("Progress")
                } currentValueLabel: {
                    Text(progress, format: .percent.precision(.fractionLength(0)))
                }
            }

            TextField("Note", text: $note)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Toggle("Show extended hierarchy", isOn: $isExpanded)

            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.28)) {
                        progress = min(1, progress + 0.08)
                    }
                } label: {
                    Label("Advance", systemImage: "forward.fill")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    isShowingDetail = true
                } label: {
                    Label("Sheet", systemImage: "rectangle.on.rectangle")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .background(CardBackground())
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Timeline", subtitle: "Repeated rows with stable identity")

            ForEach(DemoEvent.samples) { event in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(event.color.opacity(0.18))
                        Image(systemName: event.symbol)
                            .foregroundStyle(event.color)
                    }
                    .frame(width: 42, height: 42)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(event.title)
                            .font(.subheadline.weight(.semibold))
                        Text(event.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(event.badge)
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(event.color.opacity(0.16), in: Capsule())
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }

    private var disclosureFixture: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(DemoChip.samples) { chip in
                    Label(chip.title, systemImage: chip.symbol)
                        .font(.footnote)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(chip.color.opacity(0.13), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(alignment: .trailing) {
                            Capsule()
                                .fill(chip.color.opacity(0.45))
                                .frame(width: 34, height: 6)
                                .padding(.trailing, 10)
                        }
                }
            }
            .padding(.top, 10)
            .transition(.opacity.combined(with: .move(edge: .top)))
        } label: {
            SectionHeader(title: "Expanded Nodes", subtitle: "Conditional content and transitions")
        }
        .padding(16)
        .background(CardBackground())
    }
}

private struct MetricCard: View {
    let metric: DemoMetric
    let isSelected: Bool
    let namespace: Namespace.ID
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: metric.symbol)
                        .font(.title3)
                        .foregroundStyle(color)
                    Spacer()
                    Text(metric.value)
                        .font(.title3.monospacedDigit().weight(.bold))
                }
                Text(metric.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(metric.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(color, lineWidth: 2)
                        .matchedGeometryEffect(id: "selected-card-border", in: namespace)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(metric.title), \(metric.value)")
    }
}

private struct TransformTile: View {
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color.opacity(0.24))
                .frame(width: 58, height: 44)
                .overlay {
                    Image(systemName: "viewfinder")
                        .foregroundStyle(color)
                }
            Text(title)
                .font(.caption.weight(.medium))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct HeroPill: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(.white.opacity(0.45), in: Capsule())
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

private struct DetailSheet: View {
    let metric: DemoMetric
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: metric.symbol)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(metric.color)
                    .frame(width: 88, height: 88)
                    .background(metric.color.opacity(0.14), in: Circle())

                VStack(spacing: 6) {
                    Text(metric.title)
                        .font(.title3.weight(.bold))
                    Text(metric.subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding(24)
            .navigationTitle("Metric Detail")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

private enum DemoMode: String, CaseIterable, Identifiable {
    case inspect
    case animate
    case stress

    var id: String { rawValue }

    var title: String {
        switch self {
        case .inspect: "Inspect"
        case .animate: "Animate"
        case .stress: "Stress"
        }
    }

    var rotationDegrees: Double {
        switch self {
        case .inspect: 8
        case .animate: 18
        case .stress: -14
        }
    }

    var scale: CGFloat {
        switch self {
        case .inspect: 1.0
        case .animate: 1.12
        case .stress: 0.94
        }
    }
}

private struct DemoMetric: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let value: String
    let progress: Double
    let symbol: String
    let color: Color

    static let samples = [
        DemoMetric(id: "hierarchy", title: "Hierarchy", subtitle: "Stacks, overlays, masks", value: "148", progress: 0.74, symbol: "square.stack.3d.up", color: .blue),
        DemoMetric(id: "layout", title: "Layout", subtitle: "Lazy grid and fitted rows", value: "32", progress: 0.48, symbol: "rectangle.grid.2x2", color: .purple),
        DemoMetric(id: "state", title: "State", subtitle: "Controls update live nodes", value: "9", progress: 0.62, symbol: "slider.horizontal.3", color: .green),
        DemoMetric(id: "layers", title: "Layers", subtitle: "Material, gradients, shadows", value: "21", progress: 0.88, symbol: "circle.hexagongrid", color: .orange),
    ]
}

private struct DemoPalette {
    let name: String
    let primary: Color
    let accent: Color

    static let samples = [
        DemoPalette(name: "Blue", primary: .blue, accent: .cyan),
        DemoPalette(name: "Green", primary: .green, accent: .mint),
        DemoPalette(name: "Orange", primary: .orange, accent: .pink),
    ]
}

private struct DemoEvent: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let badge: String
    let symbol: String
    let color: Color

    static let samples = [
        DemoEvent(id: "start", title: "App launched", subtitle: "LookinServer starts listening", badge: "47164", symbol: "antenna.radiowaves.left.and.right", color: .blue),
        DemoEvent(id: "ping", title: "Host ping", subtitle: "Protocol version handshake", badge: "v8", symbol: "bolt.horizontal", color: .orange),
        DemoEvent(id: "tree", title: "Hierarchy request", subtitle: "SwiftUI and UIKit nodes are visible", badge: "live", symbol: "point.3.connected.trianglepath.dotted", color: .green),
    ]
}

private struct DemoChip: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let color: Color

    static let samples = [
        DemoChip(id: "modified", title: "ModifiedContent background and overlay chain", symbol: "paintbrush.pointed", color: .blue),
        DemoChip(id: "lazy", title: "LazyVGrid repeated children with stable identity", symbol: "rectangle.grid.2x2", color: .purple),
        DemoChip(id: "transition", title: "DisclosureGroup conditional subtree", symbol: "arrow.triangle.branch", color: .orange),
        DemoChip(id: "environment", title: "Environment-driven dismiss and material style", symbol: "leaf", color: .green),
    ]
}

#Preview {
    SwiftUIDemoView()
}
