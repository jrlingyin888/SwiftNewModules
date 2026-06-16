import SwiftUI

/// A labeled quantity field with a pill stepper and an inline editable count.
struct LabeledStepperQuantityField: View {
    let title: String
    var systemImage: String? = nil
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...99
    var step: Int = 1
    var tint: Color = .accentColor

    @State private var isEditing = false
    @State private var draft = ""
    @FocusState private var fieldFocused: Bool

    private var canDecrement: Bool { value - step >= range.lowerBound }
    private var canIncrement: Bool { value + step <= range.upperBound }

    var body: some View {
        HStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 24)
            }
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer(minLength: 12)

            HStack(spacing: 0) {
                stepButton(systemName: "minus", enabled: canDecrement) {
                    setValue(value - step)
                }
                countView
                    .frame(minWidth: 44)
                stepButton(systemName: "plus", enabled: canIncrement) {
                    setValue(value + step)
                }
            }
            .background(.quaternary, in: .capsule)
            .overlay(Capsule().strokeBorder(.separator, lineWidth: 0.5))
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var countView: some View {
        if isEditing {
            TextField("", text: $draft)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.body.weight(.semibold).monospacedDigit())
                .focused($fieldFocused)
                .frame(width: 44)
                .onSubmit(commitDraft)
                .onChange(of: fieldFocused) { _, focused in
                    if !focused { commitDraft() }
                }
                .accessibilityLabel(title)
        } else {
            Text("\(value)")
                .font(.body.weight(.semibold).monospacedDigit())
                .foregroundStyle(.primary)
                .contentTransition(.numericText(value: Double(value)))
                .onTapGesture { beginEditing() }
                .accessibilityElement()
                .accessibilityLabel(title)
                .accessibilityValue("\(value)")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Edit value")
                .accessibilityAction { beginEditing() }
        }
    }

    private func stepButton(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.subheadline.weight(.bold))
                .frame(width: 40, height: 36)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .foregroundStyle(enabled ? tint : Color.secondary)
        .disabled(!enabled)
        .accessibilityLabel(systemName == "plus" ? "Increase \(title)" : "Decrease \(title)")
    }

    private func beginEditing() {
        draft = "\(value)"
        withAnimation(.snappy) { isEditing = true }
        fieldFocused = true
    }

    private func commitDraft() {
        if let parsed = Int(draft) {
            setValue(parsed)
        }
        withAnimation(.snappy) { isEditing = false }
    }

    private func setValue(_ newValue: Int) {
        let clamped = min(max(newValue, range.lowerBound), range.upperBound)
        withAnimation(.snappy) { value = clamped }
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var quantity = 2
        @State private var guests = 4
        @State private var dose = 50
        var body: some View {
            Form {
                Section("Order") {
                    LabeledStepperQuantityField(title: "Quantity", systemImage: "shippingbox.fill", value: $quantity, range: 1...20)
                    LabeledStepperQuantityField(title: "Guests", systemImage: "person.2.fill", value: $guests, range: 1...12, tint: .pink)
                }
                Section("Settings") {
                    LabeledStepperQuantityField(title: "Dosage (mg)", systemImage: "pills.fill", value: $dose, range: 0...500, step: 25, tint: .teal)
                }
            }
        }
    }
    return PreviewHost()
}
