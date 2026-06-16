import SwiftUI

// MARK: - Model

struct LiquidGlassTab: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
}

// MARK: - Tab Bar (iOS 26+)

@available(iOS 26, *)
struct LiquidGlassTabBar: View {
    let tabs: [LiquidGlassTab]
    @Binding var selection: Int
    var tint: Color = .accentColor

    @Namespace private var glassNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer(spacing: 18) {
            HStack(spacing: 4) {
                ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                    tabButton(for: tab, at: index)
                }
            }
            .padding(6)
            .glassEffect(.regular, in: .capsule)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func tabButton(for tab: LiquidGlassTab, at index: Int) -> some View {
        let isSelected = selection == index
        Button {
            if reduceMotion {
                selection = index
            } else {
                withAnimation(.smooth(duration: 0.35)) { selection = index }
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .symbolVariant(isSelected ? .fill : .none)
                Text(tab.title)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? AnyShapeStyle(tint) : AnyShapeStyle(.secondary))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(.capsule)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color.clear)
                        .glassEffect(
                            .regular.tint(tint.opacity(0.22)).interactive(),
                            in: .capsule
                        )
                        .glassEffectID("tab-pill", in: glassNamespace)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }
}

// MARK: - Fallback (iOS 17-25)

struct LiquidGlassTabBarFallback: View {
    let tabs: [LiquidGlassTab]
    @Binding var selection: Int
    var tint: Color = .accentColor
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                let isSelected = selection == index
                Button {
                    withAnimation(.smooth(duration: 0.35)) { selection = index }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 18, weight: .semibold))
                            .symbolVariant(isSelected ? .fill : .none)
                        Text(tab.title)
                            .font(.system(size: 11, weight: .semibold))
                            .lineLimit(1)
                    }
                    .foregroundStyle(isSelected ? AnyShapeStyle(tint) : AnyShapeStyle(.secondary))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .contentShape(.capsule)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(tint.opacity(0.18))
                                .matchedGeometryEffect(id: "pill", in: ns)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: .capsule)
        .padding(.horizontal, 24)
    }
}

// MARK: - Demo wrapper

struct LiquidGlassTabBarDemo: View {
    @State private var selection = 0
    private let tabs = [
        LiquidGlassTab(title: "Home", systemImage: "house"),
        LiquidGlassTab(title: "Search", systemImage: "magnifyingglass"),
        LiquidGlassTab(title: "Saved", systemImage: "bookmark"),
        LiquidGlassTab(title: "Profile", systemImage: "person")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [.indigo, .purple, .pink],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Text(tabs[selection].title)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            if #available(iOS 26, *) {
                LiquidGlassTabBar(tabs: tabs, selection: $selection, tint: .white)
                    .padding(.bottom, 12)
            } else {
                LiquidGlassTabBarFallback(tabs: tabs, selection: $selection, tint: .white)
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    LiquidGlassTabBarDemo()
}
