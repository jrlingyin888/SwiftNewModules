import SwiftUI

/// A one-time-code field rendered as individual digit boxes.
struct OTPInput: View {
    let length: Int
    var onComplete: (String) -> Void = { _ in }
    @Binding var code: String

    @FocusState private var isFocused: Bool

    init(code: Binding<String>, length: Int = 6, onComplete: @escaping (String) -> Void = { _ in }) {
        self._code = code
        self.length = length
        self.onComplete = onComplete
    }

    var body: some View {
        ZStack {
            // Hidden field captures keyboard input, paste, and OTP autofill.
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .foregroundStyle(.clear)
                .tint(.clear)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .accessibilityHidden(true)

            HStack(spacing: 10) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
        .onChange(of: code) { _, newValue in
            let filtered = String(newValue.filter(\.isNumber).prefix(length))
            if filtered != newValue { code = filtered }
            if filtered.count == length {
                isFocused = false
                onComplete(filtered)
            }
        }
        .onAppear { isFocused = true }
        // Expose the field as a single accessible element so VoiceOver can
        // announce progress and activation refocuses the hidden text field.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Verification code")
        .accessibilityValue(code.isEmpty ? "Empty" : "\(code.count) of \(length) digits entered")
        .accessibilityHint("Enter the \(length)-digit code")
        .accessibilityAddTraits(.isKeyboardKey)
        .accessibilityAction { isFocused = true }
    }

    private func digitBox(at index: Int) -> some View {
        let digits = Array(code)
        let isFilled = index < digits.count
        let isCurrent = index == digits.count && isFocused

        return Text(isFilled ? String(digits[index]) : "")
            .font(.title2.weight(.semibold).monospacedDigit())
            .frame(width: 46, height: 56)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isCurrent ? Color.accentColor : (isFilled ? Color.accentColor.opacity(0.4) : Color(.separator)),
                        lineWidth: isCurrent ? 2 : 1.5
                    )
            )
            .scaleEffect(isCurrent ? 1.04 : 1)
            .animation(.snappy(duration: 0.18), value: isCurrent)
            .animation(.snappy(duration: 0.18), value: isFilled)
    }
}

#Preview {
    @Previewable @State var code = ""
    return VStack(spacing: 24) {
        Text("Enter the 6-digit code")
            .font(.headline)
        Text("Sent to +1 (555) 010-1234")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        OTPInput(code: $code) { entered in
            print("Completed: \(entered)")
        }
    }
    .padding()
}
