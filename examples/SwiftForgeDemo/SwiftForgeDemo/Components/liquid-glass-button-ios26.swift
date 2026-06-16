import SwiftUI

/// A pair of Liquid Glass buttons (prominent + plain) that fall back to
/// material-backed buttons on iOS versions earlier than 26.
///
/// Wrap one or more of these in a `GlassEffectContainer` so their shapes
/// blend and morph correctly.
struct LiquidGlassButton: View {
    let title: String
    let systemImage: String
    var prominent: Bool = false
    var tint: Color = .accentColor
    var action: () -> Void = {}

    var body: some View {
        if #available(iOS 26, *) {
            // Branch on `prominent` so each path applies a single concrete
            // ButtonStyle. A ternary can't unify `.glass` and `.glassProminent`
            // because they resolve to different opaque types.
            if prominent {
                glassLabelButton
                    .buttonStyle(.glassProminent)
                    .tint(tint)
            } else {
                glassLabelButton
                    .buttonStyle(.glass)
                    .tint(tint)
            }
        } else {
            fallbackButton
        }
    }

    // MARK: - iOS 26 label

    @available(iOS 26, *)
    private var glassLabelButton: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .padding(.horizontal, 4)
        }
    }

    // MARK: - iOS 17-25 fallback

    private var fallbackButton: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .foregroundStyle(prominent ? AnyShapeStyle(.white) : AnyShapeStyle(tint))
                .background(
                    prominent ? AnyShapeStyle(tint) : AnyShapeStyle(.ultraThinMaterial),
                    in: .capsule
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Liquid Glass Button") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .teal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: 20) {
                VStack(spacing: 20) {
                    LiquidGlassButton(
                        title: "Get Started",
                        systemImage: "sparkles",
                        prominent: true,
                        tint: .indigo
                    )
                    LiquidGlassButton(
                        title: "Learn More",
                        systemImage: "info.circle"
                    )
                }
                .padding(40)
            }
        } else {
            VStack(spacing: 20) {
                LiquidGlassButton(
                    title: "Get Started",
                    systemImage: "sparkles",
                    prominent: true,
                    tint: .indigo
                )
                LiquidGlassButton(
                    title: "Learn More",
                    systemImage: "info.circle"
                )
            }
            .padding(40)
        }
    }
}
