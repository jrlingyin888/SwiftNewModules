import SwiftUI

/// A styled search field with a clear button and focus-driven Cancel button.
struct ClearableSearchBarField: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit { onSubmit?() }
                    .accessibilityLabel(placeholder)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .scale))
                    .accessibilityLabel("Clear search text")
                }
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 12)
            .background(.quaternary.opacity(0.6), in: .rect(cornerRadius: 12))

            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .tint(.accentColor)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .accessibilityLabel("Cancel search")
            }
        }
        .animation(.snappy(duration: 0.25), value: isFocused)
        .animation(.snappy(duration: 0.2), value: text.isEmpty)
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var query = ""
        var body: some View {
            VStack(spacing: 24) {
                ClearableSearchBarField(text: $query, placeholder: "Search components")
                Text(query.isEmpty ? "Type to search…" : "Searching: \(query)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
        }
    }
    return PreviewHost()
}
