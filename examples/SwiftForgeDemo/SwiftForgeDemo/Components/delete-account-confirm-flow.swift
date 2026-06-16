import SwiftUI

struct DeleteAccountConfirmFlow: View {
    var confirmationPhrase: String = "DELETE"
    var onConfirmDelete: () async -> Void = {}

    @State private var typed = ""
    @State private var showFinalDialog = false
    @State private var isDeleting = false
    @FocusState private var fieldFocused: Bool

    private var phraseMatches: Bool {
        typed.trimmingCharacters(in: .whitespaces) == confirmationPhrase
    }

    private let consequences = [
        "Your profile and settings",
        "All saved content and history",
        "Active subscriptions and credits"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Label("This action is permanent", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(.red)
                Text("Deleting your account will immediately remove:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(consequences, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Text(item)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.red.opacity(0.08), in: .rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                Text("Type \(Text(confirmationPhrase).bold().foregroundStyle(.primary)) to confirm")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField(confirmationPhrase, text: $typed)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .focused($fieldFocused)
                    .padding(12)
                    .background(.fill.quinary, in: .rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(phraseMatches ? .green : .clear, lineWidth: 1.5)
                    )
            }

            Button(role: .destructive) {
                showFinalDialog = true
            } label: {
                HStack {
                    if isDeleting { ProgressView().tint(.white) }
                    Text(isDeleting ? "Deleting..." : "Delete my account")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .disabled(!phraseMatches || isDeleting)

            Spacer()
        }
        .padding()
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete account permanently?", isPresented: $showFinalDialog, titleVisibility: .visible) {
            Button("Delete forever", role: .destructive) {
                Task {
                    isDeleting = true
                    fieldFocused = false
                    await onConfirmDelete()
                    isDeleting = false
                }
            }
            Button("Keep my account", role: .cancel) {}
        } message: {
            Text("This cannot be undone. All your data will be erased.")
        }
    }
}

#Preview {
    NavigationStack {
        DeleteAccountConfirmFlow {
            try? await Task.sleep(for: .seconds(1.5))
        }
    }
}
