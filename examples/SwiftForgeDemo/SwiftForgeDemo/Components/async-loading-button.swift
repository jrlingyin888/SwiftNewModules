import SwiftUI

/// A primary button that performs an async action, showing a spinner and
/// disabling itself while the work is in flight.
struct AsyncLoadingButton<Label: View>: View {
    var role: ButtonRole? = nil
    var tint: Color = .accentColor
    let action: () async -> Void
    @ViewBuilder var label: () -> Label

    @State private var isRunning = false
    @Environment(\.isEnabled) private var isEnabled

    private var fillColor: Color {
        role == .destructive ? .red : tint
    }

    var body: some View {
        Button(role: role) {
            guard !isRunning else { return }
            isRunning = true
            Task {
                await action()
                isRunning = false
            }
        } label: {
            ZStack {
                // Keep intrinsic size stable between states.
                label()
                    .opacity(isRunning ? 0 : 1)
                if isRunning {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .font(.headline)
            .foregroundStyle(.white)
            .background(fillColor, in: .rect(cornerRadius: 14))
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .disabled(isRunning || !isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isRunning)
        .accessibilityValue(isRunning ? Text("Loading") : Text(""))
    }
}

#Preview {
    struct Demo: View {
        @State private var done = false

        var body: some View {
            VStack(spacing: 20) {
                AsyncLoadingButton(action: {
                    try? await Task.sleep(for: .seconds(1.5))
                    done = true
                }) {
                    Label("Save Changes", systemImage: "checkmark.circle.fill")
                }

                AsyncLoadingButton(role: .destructive, action: {
                    try? await Task.sleep(for: .seconds(1.2))
                }) {
                    Text("Delete Account")
                }

                if done {
                    Text("Saved!").foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }
    return Demo()
}
