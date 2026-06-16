import SwiftUI

/// Filled, high-emphasis button. Use for the single main action on a screen.
struct PrimaryButtonStyle: ButtonStyle {
    var tint: Color = .accentColor
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 24)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(tint, in: .rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(isEnabled ? 1 : 0.4)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
            .contentShape(.rect(cornerRadius: 14))
    }
}

/// Tinted, lower-emphasis button. Use for alternative actions next to a primary.
struct SecondaryButtonStyle: ButtonStyle {
    var tint: Color = .accentColor
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 24)
            .padding(.vertical, 14)
            .foregroundStyle(tint)
            .background(tint.opacity(0.12), in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(tint.opacity(0.25), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(isEnabled ? 1 : 0.4)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
            .contentShape(.rect(cornerRadius: 14))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { .init() }
    static func primary(tint: Color) -> PrimaryButtonStyle { .init(tint: tint) }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { .init() }
    static func secondary(tint: Color) -> SecondaryButtonStyle { .init(tint: tint) }
}

#Preview {
    VStack(spacing: 16) {
        Button("Continue") {}
            .buttonStyle(.primary)
        Button("Maybe Later") {}
            .buttonStyle(.secondary)
        Button("Delete Account") {}
            .buttonStyle(.primary(tint: .red))
        Button("Unavailable") {}
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
}
