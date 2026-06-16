import SwiftUI

/// Visual style for the circular icon button's background.
enum CircularIconButtonFill {
    case material
    case tinted(Color)
}

/// A circular icon button with an optional count badge in the top-trailing
/// corner. The badge clamps large numbers to "99+" and disappears when the
/// count is zero, mirroring the system unread-badge behavior.
struct CircularIconBadgeButton: View {
    let systemImage: String
    var accessibilityTitle: String
    var badgeCount: Int = 0
    var diameter: CGFloat = 48
    var fill: CircularIconButtonFill = .material
    var badgeTint: Color = .red
    let action: () -> Void

    private var badgeText: String { badgeCount > 99 ? "99+" : "\(badgeCount)" }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: diameter * 0.4, weight: .semibold))
                .foregroundStyle(iconStyle)
                .frame(width: diameter, height: diameter)
                .background(background)
                .clipShape(.circle)
                .overlay(alignment: .topTrailing) { badge }
        }
        .buttonStyle(CircularIconBadgePressStyle())
        .accessibilityLabel(Text(accessibilityTitle))
        .accessibilityValue(badgeCount > 0 ? Text("\(badgeCount) unread") : Text(verbatim: ""))
    }

    @ViewBuilder private var badge: some View {
        if badgeCount > 0 {
            Text(badgeText)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
                .frame(minWidth: 18, minHeight: 18)
                .background(badgeTint, in: .capsule)
                .overlay(Capsule().strokeBorder(.background, lineWidth: 2))
                .offset(x: 6, y: -6)
                .transition(.scale.combined(with: .opacity))
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder private var background: some View {
        switch fill {
        case .material: Color.clear.background(.thinMaterial)
        case .tinted(let color): color.opacity(0.18)
        }
    }

    private var iconStyle: Color {
        switch fill {
        case .material: .primary
        case .tinted(let color): color
        }
    }
}

private struct CircularIconBadgePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    @Previewable @State var notifications = 3
    return VStack(spacing: 32) {
        HStack(spacing: 20) {
            CircularIconBadgeButton(systemImage: "bell.fill", accessibilityTitle: "Notifications",
                                    badgeCount: notifications) {
                notifications = 0
            }
            CircularIconBadgeButton(systemImage: "cart.fill", accessibilityTitle: "Cart",
                                    badgeCount: 128, fill: .tinted(.blue)) {}
            CircularIconBadgeButton(systemImage: "envelope.fill", accessibilityTitle: "Mail",
                                    badgeCount: 0, fill: .tinted(.green)) {}
            CircularIconBadgeButton(systemImage: "gearshape.fill", accessibilityTitle: "Settings") {}
        }
        Button("Add notification") { withAnimation { notifications += 1 } }
            .buttonStyle(.bordered)
    }
    .padding(40)
}
