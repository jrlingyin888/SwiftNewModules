import SwiftUI

/// A social-style profile header: full-bleed cover photo with an overlapping ringed avatar.
struct CoverPhotoAvatarHeader: View {
    let cover: Image
    let avatar: Image
    let name: String
    var subtitle: String? = nil
    var coverHeight: CGFloat = 160
    var avatarSize: CGFloat = 92
    var actionTitle: String? = nil
    var onAction: () -> Void = {}

    private var accessibilityText: String {
        if let subtitle {
            return "\(name), \(subtitle)"
        }
        return name
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverImage
            HStack(alignment: .bottom) {
                avatarView
                    .offset(y: -avatarSize / 2)
                    .padding(.bottom, -avatarSize / 2)
                Spacer()
                if let actionTitle {
                    Button(actionTitle, action: onAction)
                        .font(.subheadline.weight(.semibold))
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.small)
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.title2.weight(.bold))
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    private var coverImage: some View {
        cover
            .resizable()
            .scaledToFill()
            .frame(height: coverHeight)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay {
                LinearGradient(colors: [.clear, .black.opacity(0.25)],
                               startPoint: .center, endPoint: .bottom)
            }
            .accessibilityHidden(true)
    }

    private var avatarView: some View {
        avatar
            .resizable()
            .scaledToFill()
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(.circle)
            .overlay {
                Circle().strokeBorder(Color(.systemBackground), lineWidth: 4)
            }
            .overlay {
                Circle().strokeBorder(.primary.opacity(0.08), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.18), radius: 5, y: 2)
            .accessibilityHidden(true)
    }
}

#Preview {
    ScrollView {
        CoverPhotoAvatarHeader(
            cover: Image(systemName: "mountain.2.fill"),
            avatar: Image(systemName: "person.crop.circle.fill"),
            name: "Ada Lovelace",
            subtitle: "Product Designer \u{00B7} San Francisco",
            actionTitle: "Follow"
        )
        Text("Profile content below\u{2026}")
            .frame(maxWidth: .infinity)
            .padding(.top, 24)
            .foregroundStyle(.secondary)
    }
}
