import SwiftUI

/// A reusable count badge you overlay on any view (icons, avatars, tab items).
/// - Clamps values above `maxCount` to a "maxCount+" label.
/// - Renders as a small dot when `count > 0` and `showsCount` is false.
/// - Hides entirely when `count <= 0`.
struct NotificationCountBadge: View {
    var count: Int
    var maxCount: Int = 99
    var showsCount: Bool = true
    var tint: Color = .red

    private var clampedLabel: String {
        count > maxCount ? "\(maxCount)+" : "\(count)"
    }

    var body: some View {
        // Only attach an accessibility element when something is actually shown,
        // otherwise an empty badge leaves a phantom VoiceOver element on screen.
        Group {
            if count > 0 {
                if showsCount {
                    Text(clampedLabel)
                        .font(.caption2.weight(.bold))
                        .monospacedDigit()
                        .contentTransition(.numericText(value: Double(count)))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(tint, in: .capsule)
                        .overlay(
                            Capsule().strokeBorder(.background, lineWidth: 1.5)
                        )
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityLabel("\(count) unread")
                } else {
                    Circle()
                        .fill(tint)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().strokeBorder(.background, lineWidth: 1.5))
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityLabel("Unread items")
                }
            }
        }
        .animation(.bouncy, value: count)
        .animation(.bouncy, value: showsCount)
    }
}

/// Convenience modifier to pin a badge to the top-trailing corner of any view.
extension View {
    func countBadge(_ count: Int, maxCount: Int = 99, showsCount: Bool = true, tint: Color = .red) -> some View {
        overlay(alignment: .topTrailing) {
            NotificationCountBadge(count: count, maxCount: maxCount, showsCount: showsCount, tint: tint)
                .alignmentGuide(.top) { $0[.bottom] - $0.height * 0.55 }
                .alignmentGuide(.trailing) { $0[.leading] + $0.width * 0.55 }
        }
    }
}

#Preview {
    struct BadgeDemo: View {
        @State private var count = 3
        var body: some View {
            VStack(spacing: 40) {
                HStack(spacing: 40) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.tint)
                        .countBadge(count)
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.tint)
                        .countBadge(128)
                    Image(systemName: "message.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.tint)
                        .countBadge(1, showsCount: false, tint: .green)
                }
                Stepper("Count: \(count)", value: $count, in: 0...150, step: 1)
                    .padding(.horizontal, 40)
            }
            .padding(40)
        }
    }
    return BadgeDemo()
}
