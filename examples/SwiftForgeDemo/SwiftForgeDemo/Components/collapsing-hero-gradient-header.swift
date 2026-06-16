import SwiftUI

/// A gradient hero header that collapses into a compact title bar as content scrolls.
struct CollapsingHeroGradientHeader<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var gradient: [Color] = [.indigo, .purple, .pink]
    var maxHeight: CGFloat = 260
    var minHeight: CGFloat = 92
    @ViewBuilder var content: () -> Content

    @State private var scrollOffset: CGFloat = 0

    /// 0 = fully expanded, 1 = fully collapsed.
    private var collapseProgress: CGFloat {
        let range = maxHeight - minHeight
        guard range > 0 else { return 0 }
        return min(max(scrollOffset / range, 0), 1)
    }

    private var currentHeight: CGFloat {
        max(maxHeight - scrollOffset, minHeight)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Color.clear.frame(height: maxHeight)
                content()
                    .padding(.top, 8)
            }
            .background {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("heroScroll")).minY
                    Color.clear
                        .onChange(of: minY, initial: true) { _, newValue in
                            scrollOffset = max(-newValue, 0)
                        }
                }
            }
        }
        .coordinateSpace(name: "heroScroll")
        .overlay(alignment: .top) { header }
        .ignoresSafeArea(edges: .top)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(Rectangle().fill(.ultraThinMaterial).opacity(collapseProgress))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 34 - 16 * collapseProgress, weight: .bold))
                    .foregroundStyle(.white)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .opacity(1 - collapseProgress * 1.6)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 14 + 4 * (1 - collapseProgress))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: currentHeight)
        .clipped()
        .shadow(color: .black.opacity(0.12 * collapseProgress), radius: 8, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
        .animation(.smooth(duration: 0.18), value: collapseProgress < 0.001)
    }
}

#Preview {
    CollapsingHeroGradientHeader(title: "Discover", subtitle: "Curated picks for you this week") {
        LazyVStack(spacing: 12) {
            ForEach(0..<14, id: \.self) { i in
                RoundedRectangle(cornerRadius: 14)
                    .fill(.quaternary)
                    .frame(height: 72)
                    .overlay(alignment: .leading) {
                        Text("Item \(i + 1)").padding(.leading, 16).foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 24)
    }
}
