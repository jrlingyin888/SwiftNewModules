import SwiftUI

/// An interactive star rating input supporting tap, drag-to-scrub, and VoiceOver.
struct InteractiveStarRatingInput: View {
    @Binding var rating: Int
    var maximum: Int = 5
    var allowsClearOnRetap: Bool = true
    var starSize: CGFloat = 32
    var spacing: CGFloat = 6
    var tint: Color = .yellow

    @State private var dragRating: Int?
    @State private var didDrag = false

    /// Always at least 1 so the `1...safeMaximum` range can never crash.
    private var safeMaximum: Int { max(maximum, 1) }
    private var displayed: Int { dragRating ?? rating }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...safeMaximum, id: \.self) { index in
                Image(systemName: index <= displayed ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(
                        index <= displayed
                            ? AnyShapeStyle(tint)
                            : AnyShapeStyle(.tertiary)
                    )
                    .scaleEffect(dragRating == index ? 1.18 : 1.0)
                    .animation(.bouncy(duration: 0.3), value: displayed)
                    .animation(.snappy, value: dragRating)
            }
        }
        .contentShape(.rect)
        // A single gesture is the source of truth for BOTH tap and drag so the
        // two never compete. minimumDistance: 0 means a plain tap also flows
        // through here; we detect "no movement" to apply clear-on-retap.
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if value.translation.width != 0 || value.translation.height != 0 {
                        didDrag = true
                    }
                    dragRating = star(at: value.location.x)
                }
                .onEnded { value in
                    let target = star(at: value.location.x)
                    if !didDrag, allowsClearOnRetap, rating == target {
                        rating = 0
                    } else {
                        rating = target
                    }
                    dragRating = nil
                    didDrag = false
                }
        )
        .accessibilityElement()
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating) of \(safeMaximum) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: rating = min(rating + 1, safeMaximum)
            case .decrement: rating = max(rating - 1, 0)
            @unknown default: break
            }
        }
    }

    /// Maps an x-offset within the row to a star index in `1...safeMaximum`.
    private func star(at x: CGFloat) -> Int {
        let total = CGFloat(safeMaximum) * starSize + CGFloat(safeMaximum - 1) * spacing
        guard total > 0 else { return 0 }
        let step = total / CGFloat(safeMaximum)
        let raw = Int((x / step).rounded(.up))
        return min(max(raw, 0), safeMaximum)
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var rating = 3
        var body: some View {
            VStack(spacing: 28) {
                InteractiveStarRatingInput(rating: $rating)
                InteractiveStarRatingInput(rating: $rating, maximum: 7, starSize: 24, tint: .orange)
                Text(rating == 0 ? "Not rated" : "You rated \(rating)")
                    .font(.headline)
                    .contentTransition(.numericText())
                Button("Reset") { rating = 0 }
                    .buttonStyle(.bordered)
            }
            .padding()
        }
    }
    return PreviewHost()
}
