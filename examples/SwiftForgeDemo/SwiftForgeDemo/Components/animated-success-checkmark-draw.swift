import SwiftUI

/// An animated success badge: the ring and checkmark stroke draw on, then the badge pops.
struct AnimatedSuccessCheckmarkDraw: View {
    var tint: Color = .green
    var size: CGFloat = 120
    var lineWidth: CGFloat = 8

    @State private var ringProgress: CGFloat = 0
    @State private var checkProgress: CGFloat = 0
    @State private var popScale: CGFloat = 0.6

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: ringProgress)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            SuccessCheckmarkShape()
                .trim(from: 0, to: checkProgress)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .padding(size * 0.3)
        }
        .frame(width: size, height: size)
        .scaleEffect(popScale)
        .accessibilityElement()
        .accessibilityLabel("Success")
        .accessibilityAddTraits(.isImage)
        .onAppear(perform: animate)
    }

    private func animate() {
        withAnimation(.easeOut(duration: 0.45)) { ringProgress = 1 }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { popScale = 1 }
        withAnimation(.easeOut(duration: 0.35).delay(0.35)) { checkProgress = 1 }
    }
}

/// The checkmark path, normalized into the supplied rect with a small inset so the
/// rounded line caps never clip against the frame edges.
private struct SuccessCheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: 0.06 * w, y: 0.52 * h))
        path.addLine(to: CGPoint(x: 0.40 * w, y: 0.86 * h))
        path.addLine(to: CGPoint(x: 0.94 * w, y: 0.18 * h))
        return path
    }
}

#Preview {
    AnimatedSuccessCheckmarkDraw()
        .padding()
}
