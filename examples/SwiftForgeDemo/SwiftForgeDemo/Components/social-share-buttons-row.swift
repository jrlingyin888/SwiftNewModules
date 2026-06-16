import SwiftUI

/// A single share destination shown as a labeled circular button.
struct SocialShareTarget: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let tint: Color
    let handler: () -> Void
}

/// A horizontal row of branded circular share buttons. Pass custom targets for
/// in-app destinations; the trailing `shareItem` adds a native `ShareLink` that
/// opens the full system share sheet for everything else.
struct SocialShareButtonsRow: View {
    var targets: [SocialShareTarget]
    var shareItem: URL? = nil
    var spacing: CGFloat = 20

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: spacing) {
                ForEach(targets) { target in
                    SocialShareTargetButton(target: target)
                }
                if let shareItem {
                    ShareLink(item: shareItem) {
                        SocialShareIconLabel(title: "More",
                                             systemImage: "ellipsis",
                                             tint: .secondary)
                    }
                    .buttonStyle(SocialSharePressStyle())
                    .accessibilityLabel(Text("More sharing options"))
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
}

private struct SocialShareTargetButton: View {
    let target: SocialShareTarget
    var body: some View {
        Button(action: target.handler) {
            SocialShareIconLabel(title: target.title,
                                 systemImage: target.systemImage,
                                 tint: target.tint)
        }
        .buttonStyle(SocialSharePressStyle())
        .accessibilityLabel(Text("Share via \(target.title)"))
    }
}

private struct SocialShareIconLabel: View {
    let title: String
    let systemImage: String
    let tint: Color
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(tint.gradient, in: .circle)
                .shadow(color: tint.opacity(0.35), radius: 6, y: 4)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 64)
        // The enclosing Button/ShareLink already supplies an accessibility
        // label, so collapse this decorative content into a single element
        // to avoid VoiceOver reading the glyph and title twice.
        .accessibilityElement(children: .ignore)
    }
}

private struct SocialSharePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    SocialShareButtonsRow(targets: [
        SocialShareTarget(title: "Messages", systemImage: "message.fill", tint: .green) {},
        SocialShareTarget(title: "Mail", systemImage: "envelope.fill", tint: .blue) {},
        SocialShareTarget(title: "Copy", systemImage: "link", tint: .indigo) {},
        SocialShareTarget(title: "Save", systemImage: "square.and.arrow.down", tint: .orange) {}
    ], shareItem: URL(string: "https://example.com"))
    .padding()
}
