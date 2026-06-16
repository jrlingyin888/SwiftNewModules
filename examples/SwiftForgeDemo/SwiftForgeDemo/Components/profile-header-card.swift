import SwiftUI

struct ProfileHeaderStat: Identifiable {
    let id = UUID()
    let value: String
    let label: String
}

struct ProfileHeaderCard: View {
    let name: String
    let handle: String
    let bio: String
    var avatarURL: URL? = nil
    var isVerified: Bool = false
    var stats: [ProfileHeaderStat] = []
    var isFollowing: Bool = false
    var accent: Color = .accentColor
    var onPrimaryAction: () -> Void = {}

    private let avatarSize: CGFloat = 84

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [accent, accent.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 96)
            .overlay(alignment: .bottomLeading) {
                avatar
                    .offset(x: 20, y: avatarSize / 2)
            }

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    Spacer(minLength: avatarSize + 8)
                    Button(action: onPrimaryAction) {
                        Text(isFollowing ? "Following" : "Follow")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(isFollowing ? .secondary : accent)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Text(name)
                            .font(.title3.weight(.bold))
                        if isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.subheadline)
                                .foregroundStyle(accent)
                                .accessibilityLabel("Verified")
                        }
                    }
                    Text(handle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(bio)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                if !stats.isEmpty {
                    HStack(spacing: 22) {
                        ForEach(stats) { stat in
                            HStack(spacing: 4) {
                                Text(stat.value).font(.subheadline.weight(.bold))
                                Text(stat.label).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(stat.value) \(stat.label)")
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, avatarSize / 2 + 8)
            .padding(.bottom, 20)
        }
        .background(.background, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color(.separator), lineWidth: 1))
        .clipShape(.rect(cornerRadius: 22))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }

    private var avatar: some View {
        AsyncImage(url: avatarURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            default:
                ZStack {
                    accent.opacity(0.25)
                    Text(initials)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(accent)
                }
            }
        }
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(.circle)
        .overlay(Circle().strokeBorder(Color(.systemBackground), lineWidth: 4))
        .accessibilityHidden(true)
    }

    private var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        let result = parts.compactMap { $0.first.map(String.init) }.joined().uppercased()
        return result.isEmpty ? "?" : result
    }
}

#Preview {
    ScrollView {
        ProfileHeaderCard(
            name: "Ava Mitchell",
            handle: "@avacodes",
            bio: "iOS engineer building delightful apps. Coffee, SwiftUI, and long runs.",
            isVerified: true,
            stats: [
                ProfileHeaderStat(value: "248", label: "Posts"),
                ProfileHeaderStat(value: "12.4k", label: "Followers"),
                ProfileHeaderStat(value: "389", label: "Following")
            ],
            accent: .pink
        )
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
