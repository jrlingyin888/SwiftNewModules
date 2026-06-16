import SwiftUI

/// A single tab definition for `FloatingPillTabBar`.
struct FloatingTab: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
}

/// A floating capsule tab bar with an animated selection pill.
struct FloatingPillTabBar: View {
    let tabs: [FloatingTab]
    @Binding var selection: Int

    @Namespace private var pillNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selectionAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .snappy(duration: 0.35, extraBounce: 0.1)
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                let isSelected = index == selection
                Button {
                    withAnimation(selectionAnimation) {
                        selection = index
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: tab.systemImage)
                            .symbolVariant(isSelected ? .fill : .none)
                            .imageScale(.medium)
                        if isSelected {
                            Text(tab.title)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, isSelected ? 16 : 12)
                    .foregroundStyle(isSelected ? .white : .secondary)
                    .background {
                        if isSelected {
                            Capsule(style: .continuous)
                                .fill(.tint)
                                .matchedGeometryEffect(id: "selectionPill", in: pillNamespace)
                        }
                    }
                    .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(6)
        .background(.regularMaterial, in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(.white.opacity(0.12), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.18), radius: 16, y: 8)
        .animation(selectionAnimation, value: selection)
    }
}

#Preview {
    struct Demo: View {
        @State private var selection = 0
        private let tabs = [
            FloatingTab(title: "Home", systemImage: "house"),
            FloatingTab(title: "Search", systemImage: "magnifyingglass"),
            FloatingTab(title: "Saved", systemImage: "bookmark"),
            FloatingTab(title: "Profile", systemImage: "person")
        ]

        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [.indigo.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                FloatingPillTabBar(tabs: tabs, selection: $selection)
                    .tint(.indigo)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }
    return Demo()
}
