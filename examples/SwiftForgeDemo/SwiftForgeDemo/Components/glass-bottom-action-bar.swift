import SwiftUI

/// A bottom action bar with a primary CTA and secondary icon actions.
/// On iOS 26 it adopts Liquid Glass; earlier versions fall back to material.
struct GlassBottomActionBar: View {
    var primaryTitle: String
    var primarySystemImage: String
    var secondary: [(systemImage: String, action: () -> Void)]
    var primaryAction: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    primaryButton
                        .glassEffect(.regular.tint(.accentColor).interactive(),
                                     in: .capsule)
                    ForEach(Array(secondary.enumerated()), id: \.offset) { _, item in
                        secondaryButton(item)
                            .glassEffect(.regular.interactive(), in: .circle)
                    }
                }
                .padding(.horizontal)
            }
        } else {
            HStack(spacing: 12) {
                primaryButton
                    .foregroundStyle(.white)
                    .background(.tint, in: .capsule)
                ForEach(Array(secondary.enumerated()), id: \.offset) { _, item in
                    secondaryButton(item)
                        .background(.regularMaterial, in: .circle)
                }
            }
            .padding(.horizontal)
        }
    }

    private var primaryButton: some View {
        Button(action: primaryAction) {
            Label(primaryTitle, systemImage: primarySystemImage)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.plain)
    }

    private func secondaryButton(_ item: (systemImage: String, action: () -> Void)) -> some View {
        Button(action: item.action) {
            Image(systemName: item.systemImage)
                .font(.title3)
                .frame(width: 52, height: 52)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(item.systemImage))
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        LinearGradient(colors: [.teal, .blue, .purple],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        GlassBottomActionBar(
            primaryTitle: "Add to Cart",
            primarySystemImage: "cart.fill.badge.plus",
            secondary: [
                ("heart", { print("like") }),
                ("square.and.arrow.up", { print("share") })
            ],
            primaryAction: { print("buy") }
        )
        .tint(.white)
        .padding(.bottom, 8)
    }
}
