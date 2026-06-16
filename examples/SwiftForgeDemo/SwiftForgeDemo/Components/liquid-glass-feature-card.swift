import SwiftUI

/// A Liquid Glass card (iOS 26+) with a tinted glass icon, copy, and a glass CTA.
/// Falls back to `.ultraThinMaterial` on earlier OS versions.
struct LiquidGlassFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String
    let tint: Color
    let action: () -> Void

    init(
        icon: String,
        title: String,
        subtitle: String,
        actionTitle: String = "Learn More",
        tint: Color = .blue,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.tint = tint
        self.action = action
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 20) {
                content
                    .padding(20)
                    .glassEffect(.regular, in: .rect(cornerRadius: 28))
            }
        } else {
            content
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 14) {
            iconBadge
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
            actionButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder private var iconBadge: some View {
        let symbol = Image(systemName: icon)
            .font(.title2)
            .foregroundStyle(tint)
            .frame(width: 52, height: 52)
            .accessibilityHidden(true)

        if #available(iOS 26.0, *) {
            symbol.glassEffect(.regular.tint(tint.opacity(0.18)), in: .rect(cornerRadius: 16))
        } else {
            symbol.background(tint.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    @ViewBuilder private var actionButton: some View {
        if #available(iOS 26.0, *) {
            Button(actionTitle, action: action)
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .tint(tint)
                .frame(maxWidth: .infinity)
        } else {
            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(tint)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.indigo, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        LiquidGlassFeatureCard(
            icon: "sparkles",
            title: "Smart Suggestions",
            subtitle: "On-device intelligence surfaces the right action before you ask.",
            actionTitle: "Turn On",
            tint: .cyan
        )
        .padding(32)
    }
}
