import SwiftUI

/// A multiline text editor with a placeholder, live counter, and max-length enforcement.
struct MultilineTextEditorCounter: View {
    var title: String? = nil
    var placeholder: String = "Write something\u{2026}"
    @Binding var text: String
    var characterLimit: Int = 280
    var minHeight: CGFloat = 120
    var tint: Color = .accentColor

    @FocusState private var isFocused: Bool

    private var remaining: Int { characterLimit - text.count }
    private var isOverWarning: Bool { remaining <= max(characterLimit / 10, 10) }
    private var isAtLimit: Bool { remaining <= 0 }

    private var counterColor: Color {
        if isAtLimit { return .red }
        if isOverWarning { return .orange }
        return .secondary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $text)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
            }
            .padding(8)
            .background(.fill.tertiary, in: .rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isAtLimit ? Color.red : (isFocused ? tint : Color.clear),
                        lineWidth: 1.5
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: isAtLimit)

            HStack(spacing: 6) {
                if isOverWarning {
                    Image(systemName: isAtLimit ? "exclamationmark.circle.fill" : "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(counterColor)
                }
                Spacer()
                Text("\(text.count)/\(characterLimit)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(counterColor)
                    .contentTransition(.numericText(value: Double(text.count)))
            }
            .animation(.snappy, value: counterColor)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title ?? "Text editor")
        .accessibilityValue("\(text.count) of \(characterLimit) characters used")
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var bio = ""
        @State private var note = "Picked up groceries and started drafting the proposal for next week."
        var body: some View {
            ScrollView {
                VStack(spacing: 28) {
                    MultilineTextEditorCounter(title: "Bio", placeholder: "Tell us about yourself\u{2026}", text: $bio, characterLimit: 150)
                    MultilineTextEditorCounter(title: "Note", text: $note, characterLimit: 80, minHeight: 100, tint: .purple)
                }
                .padding()
            }
        }
    }
    return PreviewHost()
}
