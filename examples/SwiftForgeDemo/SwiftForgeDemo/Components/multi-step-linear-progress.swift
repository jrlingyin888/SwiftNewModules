import SwiftUI

/// A linear, multi-step progress indicator (wizard / checkout style).
/// `currentStep` is 0-based; steps before it are completed, the rest upcoming.
struct MultiStepLinearProgress: View {
    var titles: [String]
    var currentStep: Int
    var tint: Color = .accentColor

    private var stepCount: Int { titles.count }

    private func state(for index: Int) -> StepState {
        if index < currentStep { return .completed }
        if index == currentStep { return .current }
        return .upcoming
    }

    private enum StepState { case completed, current, upcoming }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(Array(titles.indices), id: \.self) { index in
                    node(index: index)
                    if index < stepCount - 1 {
                        connector(after: index)
                    }
                }
            }
            HStack(spacing: 0) {
                ForEach(Array(titles.indices), id: \.self) { index in
                    Text(titles[index])
                        .font(.caption2)
                        .fontWeight(index == currentStep ? .semibold : .regular)
                        .foregroundStyle(index <= currentStep ? Color.primary : .secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .animation(.smooth(duration: 0.35), value: currentStep)
        .accessibilityElement()
        .accessibilityLabel("Step \(min(currentStep + 1, stepCount)) of \(stepCount)")
        .accessibilityValue(currentStep < stepCount ? titles[max(0, min(currentStep, stepCount - 1))] : "")
    }

    @ViewBuilder
    private func node(index: Int) -> some View {
        let state = state(for: index)
        ZStack {
            Circle()
                .fill(state == .upcoming ? Color(.secondarySystemFill) : tint)
                .frame(width: 28, height: 28)
            if state == .completed {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
            } else {
                Text("\(index + 1)")
                    .font(.caption.weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(state == .current ? .white : .secondary)
            }
        }
        .overlay {
            if state == .current {
                Circle().strokeBorder(tint.opacity(0.25), lineWidth: 4)
                    .frame(width: 36, height: 36)
            }
        }
        .scaleEffect(state == .current ? 1.08 : 1)
    }

    private func connector(after index: Int) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(.secondarySystemFill))
                Capsule()
                    .fill(tint)
                    .frame(width: index < currentStep ? geo.size.width : 0)
            }
        }
        .frame(height: 4)
    }
}

#Preview {
    struct StepperDemo: View {
        @State private var step = 1
        private let titles = ["Cart", "Shipping", "Payment", "Done"]
        var body: some View {
            VStack(spacing: 40) {
                MultiStepLinearProgress(titles: titles, currentStep: step, tint: .indigo)
                    .padding(.horizontal)
                HStack {
                    Button("Back") { step = max(0, step - 1) }
                        .disabled(step == 0)
                    Spacer()
                    Button("Next") { step = min(titles.count, step + 1) }
                        .disabled(step >= titles.count)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
    }
    return StepperDemo()
}
