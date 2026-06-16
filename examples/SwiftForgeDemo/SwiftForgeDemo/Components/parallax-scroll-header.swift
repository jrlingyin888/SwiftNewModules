import SwiftUI

struct ParallaxScrollHeader: View {
    var title: String = "Dolomites"
    var subtitle: String = "Northern Italy \u{00B7} 12 photos"
    var rows: [String] = (1...14).map { "Trail stop \($0)" }

    private let headerHeight: CGFloat = 280

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                LazyVStack(spacing: 12) {
                    ForEach(rows, id: \.self) { row in
                        RowCard(text: row)
                            .scrollTransition(.interactive, axis: .vertical) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                    .blur(radius: phase.isIdentity ? 0 : 6)
                                    .offset(y: phase.value * 12)
                            }
                    }
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .background(.background)
    }

    private var header: some View {
        GeometryReader { proxy in
            // Read position in the scroll view's own coordinate space so the
            // stretch baseline is a stable 0 at rest, independent of nav/safe-area.
            let minY = proxy.frame(in: .named("scroll")).minY
            let stretch = max(0, minY)
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [.indigo, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay(.black.opacity(0.15))
                .frame(height: headerHeight + stretch)
                // Parallax: rise with stretch when over-pulled, and move slower
                // than scroll (0.6x) when pushed up for a sense of depth.
                .offset(y: -stretch + (minY < 0 ? minY * 0.6 : 0))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.largeTitle.bold())
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
                .padding()
                // Title drifts slightly slower than the image for parallax depth.
                .offset(y: minY < 0 ? minY * 0.3 : 0)
            }
            .frame(height: headerHeight)
            .frame(maxWidth: .infinity)
            .clipped()
        }
        .frame(height: headerHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(subtitle)")
    }
}

private struct RowCard: View {
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mountain.2.fill")
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 40, height: 40)
                .background(.tint.opacity(0.12), in: .rect(cornerRadius: 10))
            Text(text)
                .font(.body.weight(.medium))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(.background.secondary, in: .rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.separator, lineWidth: 0.5)
        )
        .contentShape(.rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ParallaxScrollHeader()
        .coordinateSpace(.named("scroll"))
}
