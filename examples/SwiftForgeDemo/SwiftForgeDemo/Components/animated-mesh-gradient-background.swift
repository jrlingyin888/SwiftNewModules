import SwiftUI

/// A continuously drifting aurora background.
///
/// On iOS 18+ it renders a `MeshGradient` whose interior control points
/// gently breathe over time. On iOS 17 it falls back to an animated
/// `LinearGradient` with a slow hue rotation so the motion still reads.
///
/// Pass any palette of 9 colors (a 3x3 mesh). The corner points are pinned
/// to avoid seams; only the interior and edge-center points drift.
struct AnimatedMeshBackground: View {
    /// Exactly 9 colors describing a 3x3 mesh (read row-major, top-left first).
    var colors: [Color] = [
        .indigo, .purple, .blue,
        .cyan, .mint, .teal,
        .blue, .indigo, .purple
    ]

    /// Drift speed multiplier. Lower is calmer.
    var speed: Double = 0.4

    var body: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate * speed

            if #available(iOS 18, *) {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: meshPoints(t),
                    colors: colors
                )
                .ignoresSafeArea()
            } else {
                fallbackGradient(t)
            }
        }
    }

    // MARK: - iOS 18+ mesh

    private func meshPoints(_ t: Double) -> [SIMD2<Float>] {
        func drift(_ base: Float, _ phase: Double, _ amp: Float = 0.08) -> Float {
            base + Float(sin(t + phase)) * amp
        }
        return [
            SIMD2<Float>(0.0, 0.0),
            SIMD2<Float>(0.5, 0.0),
            SIMD2<Float>(1.0, 0.0),

            SIMD2<Float>(0.0, 0.5),
            SIMD2<Float>(drift(0.5, 1), drift(0.5, 2)),
            SIMD2<Float>(1.0, 0.5),

            SIMD2<Float>(0.0, 1.0),
            SIMD2<Float>(drift(0.5, 3), drift(0.5, 4)),
            SIMD2<Float>(1.0, 1.0)
        ]
    }

    // MARK: - iOS 17 fallback

    private func fallbackGradient(_ t: Double) -> some View {
        // Use the first four palette colors (or repeat) for a four-stop sweep,
        // and slowly rotate the hue + angle so it visibly drifts like the mesh.
        let stops = fallbackColors
        let angle = Angle(radians: t.truncatingRemainder(dividingBy: 2 * .pi))

        return LinearGradient(
            colors: stops,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(angle)
        .rotationEffect(angle * 0.05) // barely perceptible sway
        .scaleEffect(1.3)             // hide rotated corners
        .ignoresSafeArea()
    }

    private var fallbackColors: [Color] {
        guard !colors.isEmpty else { return [.indigo, .purple, .blue, .cyan] }
        // Sample a few evenly spaced colors for a clean multi-stop gradient.
        let indices = [0, colors.count / 3, (2 * colors.count) / 3, colors.count - 1]
        return indices.map { colors[min($0, colors.count - 1)] }
    }
}

#Preview {
    ZStack {
        AnimatedMeshBackground()
        VStack(spacing: 8) {
            Text("Good Evening")
                .font(.largeTitle.bold())
            Text("Your dashboard is ready")
                .font(.headline)
        }
        .foregroundStyle(.white)
        .shadow(radius: 8)
    }
}
