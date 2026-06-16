import SwiftUI

// MARK: - View

struct LoadingOverlay: View {
    var message: String?

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                if let message {
                    Text(message)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(28)
            .frame(minWidth: 140)
            .background(.regularMaterial, in: .rect(cornerRadius: 20))
            .shadow(color: .black.opacity(0.2), radius: 20, y: 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Modifier

struct LoadingOverlayModifier: ViewModifier {
    let isPresented: Bool
    var message: String?

    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            .overlay {
                if isPresented {
                    LoadingOverlay(message: message)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

extension View {
    /// Overlays a blocking, interaction-disabling loading scrim while `isPresented` is true.
    func loadingOverlay(isPresented: Bool, message: String? = nil) -> some View {
        modifier(LoadingOverlayModifier(isPresented: isPresented, message: message))
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var isLoading = false
        var body: some View {
            NavigationStack {
                List {
                    Button("Simulate work") {
                        isLoading = true
                        Task {
                            try? await Task.sleep(for: .seconds(2))
                            isLoading = false
                        }
                    }
                    ForEach(0..<8) { Text("Row \($0)") }
                }
                .navigationTitle("Inbox")
            }
            .loadingOverlay(isPresented: isLoading, message: "Syncing…")
        }
    }
    return Demo()
}
