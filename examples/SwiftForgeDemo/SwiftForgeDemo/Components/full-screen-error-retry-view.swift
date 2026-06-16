import SwiftUI

struct FullScreenErrorRetryView: View {
    var symbol: String = "wifi.exclamationmark"
    var title: String = "Something went wrong"
    var message: String = "We couldn't load this content. Check your connection and try again."
    var tint: Color = .red
    var retryTitle: String = "Try Again"
    var secondaryTitle: String? = nil
    var onSecondary: (() -> Void)? = nil
    var onRetry: () async -> Void

    @State private var isRetrying = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)

            Image(systemName: symbol)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 96, height: 96)
                .background(tint.opacity(0.12), in: .circle)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)

            VStack(spacing: 12) {
                Button {
                    Task {
                        isRetrying = true
                        await onRetry()
                        isRetrying = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        if isRetrying {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        Text(isRetrying ? "Retrying\u{2026}" : retryTitle)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(tint)
                .disabled(isRetrying)

                if let secondaryTitle, let onSecondary {
                    Button(secondaryTitle, action: onSecondary)
                        .font(.subheadline.weight(.semibold))
                        .tint(.secondary)
                        .disabled(isRetrying)
                }
            }
            .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .padding(28)
        .frame(maxWidth: 420)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    FullScreenErrorRetryView(
        secondaryTitle: "Contact Support",
        onSecondary: {},
        onRetry: {
            try? await Task.sleep(for: .seconds(1.5))
        }
    )
}
