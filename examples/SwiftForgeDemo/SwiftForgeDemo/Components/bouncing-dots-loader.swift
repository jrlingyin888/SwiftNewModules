import SwiftUI

/// Three dots that bounce in sequence, ideal for typing or loading states.
struct BouncingDotsLoader: View {
    var dotCount: Int = 3
    var dotSize: CGFloat = 12
    var spacing: CGFloat = 8
    var color: Color = .accentColor
    var bounceHeight: CGFloat = 10

    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(Array(0..<max(dotCount, 1)), id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    // Only translate vertically when motion is allowed.
                    .offset(y: (isAnimating && !reduceMotion) ? -bounceHeight : 0)
                    .opacity(isAnimating ? 1 : 0.4)
                    .animation(animation(for: index), value: isAnimating)
            }
        }
        // Reserve room for the bounce so dots never clip; collapse when reduced.
        .frame(height: dotSize + (reduceMotion ? 0 : bounceHeight))
        .onAppear { isAnimating = true }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }

    private func animation(for index: Int) -> Animation {
        let base = Animation
            .easeInOut(duration: reduceMotion ? 0.6 : 0.45)
            .repeatForever(autoreverses: true)
        // Stagger only when motion is allowed; otherwise pulse in unison.
        return reduceMotion ? base : base.delay(Double(index) * 0.15)
    }
}

#Preview {
    VStack(spacing: 40) {
        BouncingDotsLoader()
        BouncingDotsLoader(dotCount: 4, dotSize: 16, color: .purple, bounceHeight: 14)
        BouncingDotsLoader(dotSize: 8, color: .secondary)
            .padding()
            .background(.thinMaterial, in: .capsule)
    }
    .padding()
}
