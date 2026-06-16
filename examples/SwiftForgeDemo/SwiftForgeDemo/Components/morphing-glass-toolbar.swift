import SwiftUI

/// A morphing Liquid Glass action bar. Chips share a `GlassEffectContainer`
/// so they blend and separate fluidly when the set expands or collapses.
@available(iOS 26.0, *)
struct MorphingGlassToolbar: View {
    struct GlassAction: Identifiable {
        let id = UUID()
        let symbol: String
        let title: String
        let tint: Color
        let action: () -> Void
    }

    let actions: [GlassAction]
    var spacing: CGFloat = 18

    @State private var isExpanded = false
    @Namespace private var glassNamespace

    var body: some View {
        GlassEffectContainer(spacing: spacing) {
            HStack(spacing: spacing) {
                Button {
                    withAnimation(.bouncy(duration: 0.45)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "xmark" : "plus")
                        .font(.title2.weight(.semibold))
                        .frame(width: 56, height: 56)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.glassProminent)
                .glassEffectID("toggle", in: glassNamespace)
                .accessibilityLabel(isExpanded ? "Close actions" : "Show actions")

                if isExpanded {
                    ForEach(actions) { item in
                        Button(action: item.action) {
                            Image(systemName: item.symbol)
                                .font(.title2)
                                .frame(width: 56, height: 56)
                                .foregroundStyle(item.tint)
                        }
                        .buttonStyle(.glass)
                        .glassEffectID(item.id, in: glassNamespace)
                        .glassEffectTransition(.matchedGeometry)
                        .accessibilityLabel(item.title)
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, *)
#Preview {
    ZStack {
        LinearGradient(colors: [.indigo, .purple, .pink],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        MorphingGlassToolbar(actions: [
            .init(symbol: "square.and.arrow.up", title: "Share", tint: .white) {},
            .init(symbol: "heart.fill", title: "Like", tint: .pink) {},
            .init(symbol: "bookmark.fill", title: "Save", tint: .yellow) {},
            .init(symbol: "trash", title: "Delete", tint: .red) {}
        ])
    }
}
