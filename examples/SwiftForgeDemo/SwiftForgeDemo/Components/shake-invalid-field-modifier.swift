import SwiftUI

/// A GeometryEffect that translates a view back and forth along X.
struct InvalidShakeEffect: GeometryEffect {
    var travel: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travel * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

/// Attaches a shake that fires whenever `trigger` changes value.
struct InvalidShakeModifier: ViewModifier {
    var trigger: Int
    var travel: CGFloat = 8

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shakes: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(InvalidShakeEffect(travel: travel, animatableData: shakes))
            .onChange(of: trigger) { _, _ in
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 0.4)) { shakes += 1 }
            }
    }
}

extension View {
    /// Shakes this view each time `trigger` increments. Use on invalid form fields.
    func invalidShake(trigger: Int, travel: CGFloat = 8) -> some View {
        modifier(InvalidShakeModifier(trigger: trigger, travel: travel))
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var code = ""
        @State private var attempts = 0
        var body: some View {
            VStack(spacing: 24) {
                TextField("Access code", text: $code)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(.red.opacity(attempts > 0 ? 0.12 : 0), in: .rect(cornerRadius: 10))
                    .invalidShake(trigger: attempts)
                Button("Validate") {
                    if code != "1234" { attempts += 1 }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    return PreviewHost()
}
