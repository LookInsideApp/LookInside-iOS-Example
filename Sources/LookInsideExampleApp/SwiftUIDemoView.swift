//
//  SwiftUIDemoView.swift
//  Example-iOS
//
//  SwiftUI surface for verifying the LookInside SwiftUI inspector. Each row
//  exercises a distinct SwiftUI _ViewDebug.Property kind so the seven attr
//  groups (Type / Layout / Transform / Phase / LayoutComputer / DisplayList /
//  Layers / Environment) all have populated nodes to inspect.
//

import SwiftUI

struct SwiftUIDemoView: View {
    @State private var tapCount = 0
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SwiftUI Demo")
                .font(.headline)
                .foregroundColor(.blue)

            // Environment + nested layout (VStack > HStack > Image + Text).
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("Hello, Lookin")
                    .font(.body)
            }

            // Pure translation. Triggers ViewTransform.Item.translation case.
            Text("Translated +10x / -4y")
                .padding(8)
                .background(Color(red: 0, green: 0.78, blue: 0.78).opacity(0.2))
                .cornerRadius(6)
                .offset(x: 10, y: -4)

            // Rotation + uniform scale. Triggers ViewTransform.Item.affineTransform.
            Text("Rotated 12° / scaled 1.1×")
                .padding(8)
                .background(Color.green.opacity(0.2))
                .cornerRadius(6)
                .rotationEffect(.degrees(12))
                .scaleEffect(1.1)

            // Custom 2D affine. Should collapse via tryCGAffineFromMatrix4.
            Text("Custom affine")
                .padding(8)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(6)
                .transformEffect(
                    CGAffineTransform(translationX: 12, y: 0)
                        .scaledBy(x: 0.95, y: 0.95)
                )

            // Pure layout container (Circles inside HStack). Layout-only nodes
            // have empty displayListIdentityIDs - SwiftUI Layers group should
            // be omitted on the HStack itself but present on each Circle.
            HStack(spacing: 4) {
                ForEach(0 ..< 4, id: \.self) { swatchIndex in
                    Circle()
                        .fill(Color.purple.opacity(0.3 + Double(swatchIndex) * 0.15))
                        .frame(width: 24, height: 24)
                }
            }

            // Tap interaction toggles isExpanded -> conditional content
            // mounts/unmounts -> Phase rows populate when SWIFTUI_VIEW_DEBUG=511.
            Button {
                tapCount += 1
                withAnimation(.easeInOut(duration: 0.4)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill")
                    Text("Tap (\(tapCount))")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(8)
            }

            if isExpanded {
                Text("Expanded content")
                    .padding(8)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(6)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    SwiftUIDemoView()
        .padding()
}
