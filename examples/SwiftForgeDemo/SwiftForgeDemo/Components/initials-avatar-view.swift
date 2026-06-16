import SwiftUI

/// A circular avatar with image support and a deterministic colored-initials fallback.
struct InitialsAvatarView: View {
    let name: String
    var imageURL: URL? = nil
    var size: CGFloat = 56
    /// When set, draws a small status dot in the lower-trailing corner.
    var statusColor: Color? = nil

    private var initials: String {
        let parts = name
            .split(whereSeparator: { $0.isWhitespace })
            .prefix(2)
        let letters = parts.compactMap { $0.first.map(String.init) }
        let result = letters.joined().uppercased()
        return result.isEmpty ? "?" : result
    }

    /// Stable hue from the name so the same person always gets the same color.
    private var fallbackColor: Color {
        let hash = abs(name.unicodeScalars.reduce(5381) { ($0 &* 33) &+ Int($1.value) })
        let hue = Double(hash % 360) / 360
        return Color(hue: hue, saturation: 0.55, brightness: 0.75)
    }

    var body: some View {
        avatarContent
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(.white.opacity(0.18), lineWidth: 1))
            .overlay(alignment: .bottomTrailing) { statusBadge }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(name)
            .accessibilityAddTraits(.isImage)
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let imageURL {
            AsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    initialsFallback
                }
            }
        } else {
            initialsFallback
        }
    }

    private var initialsFallback: some View {
        LinearGradient(
            colors: [fallbackColor.opacity(0.95), fallbackColor.opacity(0.65)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            Text(initials)
                .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        )
    }

    @ViewBuilder
    private var statusBadge: some View {
        if let statusColor {
            Circle()
                .fill(statusColor)
                .frame(width: size * 0.28, height: size * 0.28)
                .overlay(Circle().strokeBorder(Color(.systemBackground), lineWidth: size * 0.05))
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    VStack(spacing: 28) {
        HStack(spacing: 16) {
            InitialsAvatarView(name: "Ada Lovelace", statusColor: .green)
            InitialsAvatarView(name: "Grace Hopper")
            InitialsAvatarView(name: "Linus Torvalds", statusColor: .orange)
            InitialsAvatarView(name: "Margaret Hamilton")
        }
        InitialsAvatarView(
            name: "Alan Turing",
            imageURL: URL(string: "https://i.pravatar.cc/200?img=12"),
            size: 96,
            statusColor: .green
        )
    }
    .padding()
}
