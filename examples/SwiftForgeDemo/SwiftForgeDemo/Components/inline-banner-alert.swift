import SwiftUI

enum InlineBannerAlertKind {
    case info, success, warning, error

    var symbol: String {
        switch self {
        case .info: "info.circle.fill"
        case .success: "checkmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .error: "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .info: .blue
        case .success: .green
        case .warning: .orange
        case .error: .red
        }
    }

    var accessibilityPrefix: String {
        switch self {
        case .info: "Information"
        case .success: "Success"
        case .warning: "Warning"
        case .error: "Error"
        }
    }
}

struct InlineBannerAlert: View {
    let kind: InlineBannerAlertKind
    let title: String
    var message: String? = nil
    var actionTitle: String? = nil
    var onAction: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil

    private var accessibilityText: String {
        [kind.accessibilityPrefix, title, message]
            .compactMap { $0 }
            .joined(separator: ", ")
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: kind.symbol)
                .font(.title3)
                .foregroundStyle(kind.tint)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    if let message {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityText)

                if let actionTitle, let onAction {
                    Button(actionTitle, action: onAction)
                        .font(.footnote.weight(.semibold))
                        .tint(kind.tint)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let onDismiss {
                Button(role: .cancel, action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .padding(6)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss")
            }
        }
        .padding(14)
        .background(kind.tint.opacity(0.12), in: .rect(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(kind.tint.opacity(0.25), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            InlineBannerAlert(kind: .info, title: "Heads up", message: "Your trial ends in 3 days.")
            InlineBannerAlert(kind: .success, title: "Saved", message: "Your changes are live.", onDismiss: {})
            InlineBannerAlert(kind: .warning, title: "Low storage", message: "Free up space to keep syncing.", actionTitle: "Manage", onAction: {})
            InlineBannerAlert(kind: .error, title: "Payment failed", message: "Update your card to continue.", actionTitle: "Retry", onAction: {}, onDismiss: {})
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
