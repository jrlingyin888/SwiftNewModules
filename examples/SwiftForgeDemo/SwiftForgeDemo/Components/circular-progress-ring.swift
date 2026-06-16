import SwiftUI

struct CircularProgressRing: View {
    /// Progress from 0.0 to 1.0.
    var progress: Double
    var lineWidth: CGFloat = 14
    var gradient: Gradient = Gradient(colors: [.blue, .cyan])
    var trackColor: Color = .gray.opacity(0.18)
    var showsLabel: Bool = true

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, style: StrokeStyle(lineWidth: lineWidth))

            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    AngularGradient(
                        gradient: gradient,
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.85), value: clamped)

            if showsLabel {
                Text(clamped, format: .percent.precision(.fractionLength(0)))
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText(value: clamped))
                    .animation(.spring(response: 0.6, dampingFraction: 0.85), value: clamped)
            }
        }
        .padding(lineWidth / 2)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(clamped.formatted(.percent.precision(.fractionLength(0))))
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var progress: Double = 0.25
        var body: some View {
            VStack(spacing: 40) {
                CircularProgressRing(progress: progress)
                    .frame(width: 160, height: 160)

                HStack(spacing: 16) {
                    Button("-20%") { progress = max(0, progress - 0.2) }
                    Button("+20%") { progress = min(1, progress + 0.2) }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
    return Demo()
}
