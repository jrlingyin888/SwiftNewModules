import SwiftUI

enum LabeledDividerAlignment {
    case leading, center, trailing
}

struct LabeledContentDivider: View {
    var title: String
    var systemImage: String? = nil
    var alignment: LabeledDividerAlignment = .center
    var lineColor: Color = Color(.separator)
    var lineHeight: CGFloat = 1

    private var label: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(title)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .textCase(.uppercase)
        .fixedSize()
    }

    private var rule: some View {
        Rectangle()
            .fill(lineColor)
            .frame(height: lineHeight)
    }

    var body: some View {
        HStack(spacing: 12) {
            if alignment != .leading { rule }
            label
            if alignment != .trailing { rule }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    VStack(spacing: 28) {
        LabeledContentDivider(title: "Or continue with")
        LabeledContentDivider(title: "Today", systemImage: "calendar", alignment: .leading)
        LabeledContentDivider(title: "Archived", alignment: .trailing)
        LabeledContentDivider(title: "Recent", systemImage: "clock", alignment: .center, lineColor: .blue.opacity(0.4))
    }
    .padding()
}
