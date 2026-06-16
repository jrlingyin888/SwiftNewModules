import SwiftUI

/// A diagonal shimmer sweep usable on any view (great over `.redacted`).
struct ShimmerModifier: ViewModifier {
    var active: Bool = true
    var duration: Double = 1.3
    var bandWidth: CGFloat = 0.3

    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isAnimating: Bool { active && !reduceMotion }

    func body(content: Content) -> some View {
        content.overlay {
            if isAnimating {
                GeometryReader { geo in
                    let w = geo.size.width
                    let band = max(w * bandWidth, 1)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .white.opacity(0.55), location: 0.5),
                                    .init(color: .clear, location: 1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: band)
                        // Travels from fully off the leading edge to fully off the trailing edge.
                        .offset(x: phase * (w + band))
                        .blendMode(.plusLighter)
                }
                .mask(content)
                .allowsHitTesting(false)
                .onAppear {
                    // Reset so the sweep always starts off-screen, even when
                    // `active` toggles back on after a previous run.
                    phase = -1
                    withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
        }
        // Restart the sweep cleanly whenever the active state flips on.
        .id(isAnimating)
    }
}

extension View {
    /// Sweeps a soft highlight across the view to signal loading.
    func shimmering(
        active: Bool = true,
        duration: Double = 1.3,
        bandWidth: CGFloat = 0.3
    ) -> some View {
        modifier(ShimmerModifier(active: active, duration: duration, bandWidth: bandWidth))
    }
}

/// A redacted placeholder row that shimmers while `isLoading`.
struct SkeletonRow: View {
    var isLoading: Bool = true

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 14)
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 14)
                    .frame(maxWidth: 160)
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(.quaternary)
        .redacted(reason: isLoading ? .placeholder : [])
        .shimmering(active: isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        ForEach(0..<5, id: \.self) { _ in
            SkeletonRow()
        }
    }
    .padding()
}
