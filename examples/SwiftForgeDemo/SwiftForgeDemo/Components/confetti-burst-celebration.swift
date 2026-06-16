import SwiftUI

/// A radial confetti burst. Increment `trigger` to fire a new celebration.
struct ConfettiBurstCelebration: View {
    var trigger: Int
    var pieceCount: Int = 28
    var colors: [Color] = [.pink, .orange, .yellow, .green, .blue, .purple]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pieces: [ConfettiPieceModel] = []

    var body: some View {
        ZStack {
            ForEach(pieces) { piece in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(piece.color)
                    .frame(width: 7, height: 11)
                    .scaleEffect(piece.active ? 1 : 0.3)
                    .rotationEffect(.degrees(piece.active ? piece.spin : 0))
                    .offset(x: piece.active ? piece.dx : 0,
                            y: piece.active ? piece.dy : 0)
                    .opacity(piece.active ? 0 : 1)
            }
        }
        .accessibilityHidden(true)
        .onChange(of: trigger) { _, _ in burst() }
    }

    private func burst() {
        // Guard against an empty palette to avoid division-by-zero and
        // out-of-range crashes when a caller passes `colors: []`.
        let palette = colors.isEmpty ? [Color.accentColor] : colors
        let count = max(0, pieceCount)
        guard count > 0 else {
            pieces = []
            return
        }

        pieces = (0..<count).map { i in
            let angle = (Double(i) / Double(count)) * 2 * .pi
            let distance = Double.random(in: 90...170)
            return ConfettiPieceModel(
                dx: cos(angle) * distance,
                dy: sin(angle) * distance,
                spin: Double.random(in: 180...540),
                color: palette[i % palette.count])
        }

        // Respect reduce-motion: skip the fly-out animation and resolve
        // particles instantly so the effect stays subtle.
        guard !reduceMotion else {
            for index in pieces.indices {
                pieces[index].active = true
            }
            return
        }

        for index in pieces.indices {
            withAnimation(.easeOut(duration: Double.random(in: 0.8...1.2))) {
                pieces[index].active = true
            }
        }
    }
}

private struct ConfettiPieceModel: Identifiable {
    let id = UUID()
    var dx: Double
    var dy: Double
    var spin: Double
    var color: Color
    var active: Bool = false
}

#Preview {
    struct PreviewHost: View {
        @State private var trigger = 0
        var body: some View {
            VStack(spacing: 40) {
                ConfettiBurstCelebration(trigger: trigger)
                    .frame(width: 200, height: 200)
                Button("Celebrate") { trigger += 1 }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    return PreviewHost()
}
