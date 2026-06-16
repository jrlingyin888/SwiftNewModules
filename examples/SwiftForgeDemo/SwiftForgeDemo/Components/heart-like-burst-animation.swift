import SwiftUI

/// A like button that bursts a ring of particles and pops the heart when liked.
struct HeartLikeBurstButton: View {
    @State private var isLiked = false
    @State private var burstID = 0

    var likedColor: Color = .pink
    var size: CGFloat = 44
    var particleCount: Int = 8
    var onToggle: ((Bool) -> Void)? = nil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var resolvedCount: Int { max(0, particleCount) }

    var body: some View {
        Button {
            isLiked.toggle()
            if isLiked && !reduceMotion { burstID += 1 }
            onToggle?(isLiked)
        } label: {
            ZStack {
                if isLiked && !reduceMotion {
                    HeartLikeBurstParticles(count: resolvedCount, color: likedColor, size: size)
                        .id(burstID)
                }
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: size, weight: .semibold))
                    .foregroundStyle(isLiked ? AnyShapeStyle(likedColor) : AnyShapeStyle(.secondary))
                    .scaleEffect(isLiked ? 1 : 0.92)
                    .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.45), value: isLiked)
                    .symbolEffect(.bounce, value: isLiked)
            }
            .frame(width: size * 2, height: size * 2)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Like")
        .accessibilityValue(isLiked ? "Liked" : "Not liked")
    }
}

private struct HeartLikeBurstParticles: View {
    let count: Int
    let color: Color
    let size: CGFloat
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: size * 0.16, height: size * 0.16)
                    .scaleEffect(animate ? 0.2 : 1)
                    .offset(offset(for: index))
                    .opacity(animate ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.55)) { animate = true }
        }
    }

    private func offset(for index: Int) -> CGSize {
        guard count > 0 else { return .zero }
        let angle = (Double(index) / Double(count)) * 2 * .pi
        let radius = animate ? size * 0.95 : size * 0.2
        return CGSize(width: cos(angle) * radius, height: sin(angle) * radius)
    }
}

#Preview {
    HeartLikeBurstButton(likedColor: .red) { liked in
        print("Liked: \(liked)")
    }
    .padding(40)
}
