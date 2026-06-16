import SwiftUI

/// A counter that animates each digit independently, rolling like an odometer toward a new value.
///
/// Each digit is keyed by its place value (ones, tens, hundreds, …) rather than its left-to-right
/// position, so that when the number of digits changes (e.g. 999 → 1000) the new leading digit is
/// inserted/removed on the left with a push transition, while the unchanged trailing digits morph
/// in place via `.numericText`. Driven purely by `value`; change it inside `@State` to animate.
struct RollingNumberCounter: View {
    let value: Int
    var font: Font = .system(size: 48, weight: .bold, design: .rounded)
    var color: Color = .primary
    var animation: Animation = .spring(response: 0.6, dampingFraction: 0.85)

    /// Each digit paired with its place value (1 = ones, 2 = tens, …) for stable identity.
    private var placedDigits: [(place: Int, value: Int)] {
        let chars = Array(String(abs(value)))
        let count = chars.count
        return chars.enumerated().map { offset, char in
            (place: count - offset, value: char.wholeNumberValue ?? 0)
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            if value < 0 {
                Text(verbatim: "-")
                    .font(font)
                    .foregroundStyle(color)
            }
            ForEach(placedDigits, id: \.place) { item in
                RollingCounterDigit(digit: item.value, font: font, color: color)
            }
        }
        .animation(animation, value: value)
        .monospacedDigit()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(value.formatted()))
    }
}

/// A single digit slot that morphs through intermediate numbers (odometer style) when its value
/// changes, and pushes in/out when the slot itself is inserted or removed.
private struct RollingCounterDigit: View {
    let digit: Int
    let font: Font
    let color: Color

    var body: some View {
        Text(verbatim: String(digit))
            .font(font)
            .foregroundStyle(color)
            .contentTransition(.numericText(value: Double(digit)))
            .transition(.push(from: .bottom).combined(with: .opacity))
    }
}

#Preview {
    struct CounterPreview: View {
        @State private var value = 1234
        var body: some View {
            VStack(spacing: 32) {
                RollingNumberCounter(value: value)
                HStack(spacing: 16) {
                    Button("-250") { value -= 250 }
                    Button("Random") { value = Int.random(in: 0...99999) }
                    Button("+250") { value += 250 }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
    return CounterPreview()
}
