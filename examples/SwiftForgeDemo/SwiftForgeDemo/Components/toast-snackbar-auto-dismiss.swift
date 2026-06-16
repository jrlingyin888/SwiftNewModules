import SwiftUI

// MARK: - Model

struct Toast: Equatable, Identifiable {
    enum Style {
        case success, error, info, warning

        var icon: String {
            switch self {
            case .success: "checkmark.circle.fill"
            case .error:   "xmark.octagon.fill"
            case .info:    "info.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            }
        }

        var tint: Color {
            switch self {
            case .success: .green
            case .error:   .red
            case .info:    .blue
            case .warning: .orange
            }
        }
    }

    let id = UUID()
    var style: Style = .info
    var title: String
    var message: String? = nil
    var duration: Double = 2.5
}

// MARK: - View

struct ToastView: View {
    let toast: Toast

    private var accessibilityText: String {
        if let message = toast.message, !message.isEmpty {
            "\(toast.title). \(message)"
        } else {
            toast.title
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.style.icon)
                .font(.title3)
                .foregroundStyle(toast.style.tint)
                .symbolRenderingMode(.hierarchical)
            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                if let message = toast.message, !message.isEmpty {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(.regularMaterial, in: .rect(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(toast.style.tint.opacity(0.25), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to dismiss")
    }
}

// MARK: - Modifier

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast {
                    ToastView(toast: toast)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onTapGesture { dismiss() }
                        // Structured timer keyed on the toast's id: re-triggering a
                        // new toast cancels the prior timer automatically.
                        .task(id: toast.id) {
                            try? await Task.sleep(for: .seconds(toast.duration))
                            guard !Task.isCancelled else { return }
                            dismiss()
                        }
                }
            }
            .animation(animation, value: toast)
    }

    private var animation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.4, dampingFraction: 0.8)
    }

    private func dismiss() {
        withAnimation(animation) { toast = nil }
    }
}

extension View {
    /// Presents a toast bound to an optional `Toast` value; auto-dismisses after its duration.
    func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var toast: Toast?

        var body: some View {
            VStack(spacing: 16) {
                Button("Show Success") {
                    toast = Toast(style: .success, title: "Saved", message: "Your changes are live.")
                }
                Button("Show Error") {
                    toast = Toast(style: .error, title: "Upload failed", message: "Tap to dismiss.")
                }
                Button("Show Info (no message)") {
                    toast = Toast(style: .info, title: "Syncing…")
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast($toast)
        }
    }
    return Demo()
}
