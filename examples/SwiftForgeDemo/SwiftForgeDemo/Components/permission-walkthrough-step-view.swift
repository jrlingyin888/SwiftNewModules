import SwiftUI

struct PermissionWalkthroughStepView: View {
    var symbol: String
    var title: String
    var reason: String
    var detail: String
    var tint: Color = .blue
    var stepIndex: Int
    var stepCount: Int
    var allowTitle: String = "Allow Access"
    var skipTitle: String = "Not Now"
    var onAllow: () -> Void = {}
    var onSkip: () -> Void = {}

    @State private var pulse = false

    var body: some View {
        VStack(spacing: 0) {
            PermissionStepProgressBar(current: stepIndex, total: stepCount, tint: tint)
                .padding(.horizontal, 24)
                .padding(.top, 12)

            Spacer()

            ZStack {
                Circle()
                    .fill(tint.opacity(0.15))
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulse ? 1.08 : 0.94)
                Image(systemName: symbol)
                    .font(.system(size: 60, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(tint)
            }
            .accessibilityHidden(true)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }

            VStack(spacing: 14) {
                Text(title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(reason)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)
            .padding(.top, 28)
            .accessibilityElement(children: .combine)

            Spacer()

            VStack(spacing: 12) {
                Button(action: onAllow) {
                    Text(allowTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(tint)

                Button(skipTitle, role: .cancel, action: onSkip)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

private struct PermissionStepProgressBar: View {
    let current: Int
    let total: Int
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<max(total, 1), id: \.self) { index in
                Capsule()
                    .fill(index <= current ? tint : Color.secondary.opacity(0.25))
                    .frame(height: 5)
            }
        }
        .animation(.smooth, value: current)
        .accessibilityElement()
        .accessibilityLabel("Step \(current + 1) of \(total)")
    }
}

#Preview {
    PermissionWalkthroughStepView(
        symbol: "bell.badge.fill",
        title: "Stay in the loop",
        reason: "Turn on notifications to never miss a reminder.",
        detail: "We'll only notify you about things you've asked us to track. You can change this anytime in Settings.",
        tint: .orange,
        stepIndex: 1,
        stepCount: 3
    )
}
