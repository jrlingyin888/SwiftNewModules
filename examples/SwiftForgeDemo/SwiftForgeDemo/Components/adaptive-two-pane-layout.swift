import SwiftUI

struct AdaptiveTwoPaneLayout<Primary: View, Secondary: View>: View {
    /// Fraction of width given to the primary pane in regular width (0–1).
    var primaryFraction: CGFloat = 0.6
    var spacing: CGFloat = 16
    @ViewBuilder var primary: Primary
    @ViewBuilder var secondary: Secondary

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var isWide: Bool { sizeClass == .regular }

    /// Clamp the fraction so a stray value can't drive a negative/overflowing width.
    private var clampedFraction: CGFloat { min(max(primaryFraction, 0), 1) }

    var body: some View {
        if isWide {
            GeometryReader { proxy in
                let available = max(proxy.size.width - spacing, 0)
                let primaryWidth = available * clampedFraction
                HStack(alignment: .top, spacing: spacing) {
                    primary
                        .frame(width: primaryWidth)
                    secondary
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        } else {
            VStack(alignment: .leading, spacing: spacing) {
                primary
                secondary
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    AdaptiveTwoPaneLayout(primaryFraction: 0.55) {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue.gradient)
            .overlay(Text("Primary").font(.title.bold()).foregroundStyle(.white))
            .frame(height: 240)
    } secondary: {
        VStack(alignment: .leading, spacing: 12) {
            Text("Secondary")
                .font(.title2.bold())
            Text("This pane sits beside the primary content on iPad and regular-width windows, and stacks beneath it on compact iPhone layouts.")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxHeight: 240, alignment: .top)
    }
    .padding()
}
