import SwiftUI

/// A tappable media thumbnail with a frosted play badge and optional duration pill.
struct PlayBadgeMediaThumbnail: View {
    let artwork: Image
    var title: String? = nil
    var duration: String? = nil
    var aspectRatio: CGFloat = 16.0 / 9.0
    var onTap: () -> Void = {}

    @State private var pressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                thumbnail
                if let title {
                    Text(title)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(2)
                        .foregroundStyle(.primary)
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(pressed ? 0.96 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: pressed)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressed = $0 }, perform: {})
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title ?? "Video")
        .accessibilityValue(duration.map { "Duration \($0)" } ?? "")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Plays media")
    }

    private var thumbnail: some View {
        Color.clear
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay {
                artwork
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(.rect(cornerRadius: 14))
            .overlay {
                LinearGradient(colors: [.clear, .black.opacity(0.45)],
                               startPoint: .center, endPoint: .bottom)
                    .clipShape(.rect(cornerRadius: 14))
            }
            .overlay { playBadge }
            .overlay(alignment: .bottomTrailing) { durationPill }
            .contentShape(.rect(cornerRadius: 14))
    }

    private var playBadge: some View {
        Image(systemName: "play.fill")
            .font(.title3.weight(.bold))
            .foregroundStyle(.white)
            .padding(16)
            .background(.ultraThinMaterial, in: .circle)
            .overlay(Circle().strokeBorder(.white.opacity(0.35), lineWidth: 1))
            .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
    }

    @ViewBuilder private var durationPill: some View {
        if let duration {
            Text(duration)
                .font(.caption2.weight(.semibold).monospacedDigit())
                .foregroundStyle(.white)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(.black.opacity(0.55), in: .capsule)
                .padding(8)
        }
    }
}

#Preview {
    let cols = [GridItem(.adaptive(minimum: 150), spacing: 12)]
    return ScrollView {
        LazyVGrid(columns: cols, spacing: 16) {
            PlayBadgeMediaThumbnail(artwork: Image(systemName: "mountain.2.fill"),
                                    title: "Sunrise over the Alps", duration: "4:21")
            PlayBadgeMediaThumbnail(artwork: Image(systemName: "film.fill"),
                                    title: "Behind the scenes", duration: "12:08")
            PlayBadgeMediaThumbnail(artwork: Image(systemName: "waveform"),
                                    title: "Studio session", duration: "0:45")
        }
        .padding()
    }
}
