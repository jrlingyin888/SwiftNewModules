import SwiftUI

/// A reusable empty-state view: icon, title, message, and an optional action button.
/// Center it in a ScrollView/List background or a ZStack when a collection is empty.
struct EmptyStatePlaceholderView: View {
    var systemImage: String = "tray"
    var title: String
    var message: String
    var actionTitle: String? = nil
    var tint: Color = .accentColor
    var action: (() -> Void)? = nil

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.12))
                    .frame(width: 96, height: 96)
                Image(systemName: systemImage)
                    .font(.system(size: 40, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(tint)
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)
            .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .fixedSize(horizontal: false, vertical: true)
            // Combine only the text block so the CTA below stays its own VoiceOver control.
            .accessibilityElement(children: .combine)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(tint)
                .padding(.top, 4)
            }
        }
        .padding(32)
        .frame(maxWidth: 360)
        .onAppear {
            withAnimation(.smooth(duration: 0.45)) { appeared = true }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            EmptyStatePlaceholderView(
                systemImage: "tray",
                title: "No Messages Yet",
                message: "When you receive messages, they\u{2019}ll show up right here.",
                actionTitle: "Start a Conversation",
                tint: .blue,
                action: {}
            )
            Divider()
            EmptyStatePlaceholderView(
                systemImage: "magnifyingglass",
                title: "No Results",
                message: "Try a different search term or check your spelling.",
                tint: .orange
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
