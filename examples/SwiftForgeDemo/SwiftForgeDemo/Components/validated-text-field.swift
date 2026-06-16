import SwiftUI

/// A text field with inline validation, focus styling, and an animated error message.
struct ValidatedTextField: View {
    let title: String
    let prompt: String
    var systemImage: String? = nil
    var keyboard: UIKeyboardType = .default
    /// Return nil when valid, or an error message when invalid.
    let validate: (String) -> String?
    @Binding var text: String

    @FocusState private var isFocused: Bool
    @State private var errorMessage: String?
    @State private var hasEdited = false

    private var borderColor: Color {
        if errorMessage != nil { return .red }
        return isFocused ? .accentColor : Color(.separator)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundStyle(isFocused ? Color.accentColor : .secondary)
                        .frame(width: 20)
                        .accessibilityHidden(true)
                }

                TextField(prompt, text: $text)
                    .focused($isFocused)
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .onSubmit {
                        hasEdited = true
                        errorMessage = validate(text)
                    }

                if !text.isEmpty {
                    Button {
                        text = ""
                        if hasEdited { errorMessage = validate("") }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear text")
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.18), value: borderColor)

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.snappy(duration: 0.2), value: errorMessage)
        .onChange(of: text) { _, newValue in
            if hasEdited { errorMessage = validate(newValue) }
        }
        .onChange(of: isFocused) { _, focused in
            if !focused {
                hasEdited = true
                errorMessage = validate(text)
            }
        }
    }
}

/// Common validators.
enum FieldValidator {
    static func email(_ value: String) -> String? {
        if value.isEmpty { return "Email is required" }
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return value.range(of: pattern, options: .regularExpression) == nil
            ? "Enter a valid email address" : nil
    }
}

#Preview {
    @Previewable @State var email = ""

    Form {
        Section {
            ValidatedTextField(
                title: "Email",
                prompt: "you@example.com",
                systemImage: "envelope",
                keyboard: .emailAddress,
                validate: FieldValidator.email,
                text: $email
            )
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .padding(.vertical, 4)
        }
    }
}
