import SwiftUI

/// A tag/token input where each committed entry becomes a removable chip.
struct TokenTagInputField: View {
    @Binding var tokens: [String]
    var placeholder: String = "Add tag"
    var maxTokens: Int? = nil

    @State private var draft: String = ""
    @FocusState private var isFocused: Bool

    private var canAddMore: Bool {
        guard let maxTokens else { return true }
        return tokens.count < maxTokens
    }

    var body: some View {
        TokenFlowLayout(spacing: 8, lineSpacing: 8) {
            ForEach(tokens, id: \.self) { token in
                TokenChip(text: token) { remove(token) }
            }
            if canAddMore {
                TextField(tokens.isEmpty ? placeholder : "", text: $draft)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(minWidth: 80)
                    .fixedSize()
                    .onChange(of: draft) { _, newValue in
                        if newValue.hasSuffix(",") || newValue.hasSuffix("\n") {
                            commit()
                        }
                    }
                    .onSubmit { commit() }
                    .accessibilityLabel(placeholder)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.5), in: .rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isFocused ? Color.accentColor : .clear, lineWidth: 1.5)
        )
        .contentShape(.rect)
        .onTapGesture { isFocused = true }
        .animation(.snappy(duration: 0.2), value: tokens)
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    private func commit() {
        let cleaned = draft
            .trimmingCharacters(in: CharacterSet(charactersIn: ",\n"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        defer { draft = "" }
        guard !cleaned.isEmpty, canAddMore,
              !tokens.contains(where: { $0.caseInsensitiveCompare(cleaned) == .orderedSame })
        else { return }
        tokens.append(cleaned)
    }

    private func remove(_ token: String) {
        tokens.removeAll { $0 == token }
    }
}

private struct TokenChip: View {
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            Text(text)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(text)")
        }
        .foregroundStyle(.tint)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.tint.opacity(0.15), in: .capsule)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tag: \(text)")
    }
}

/// A simple flow layout that wraps subviews onto new lines when they overflow.
private struct TokenFlowLayout: Layout {
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var maxRowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0
        var isFirstInRow = true

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if !isFirstInRow, x + spacing + size.width > maxWidth {
                // Wrap to a new row.
                maxRowWidth = max(maxRowWidth, x)
                totalHeight += rowHeight + lineSpacing
                x = 0
                rowHeight = 0
                isFirstInRow = true
            }
            x += isFirstInRow ? size.width : spacing + size.width
            rowHeight = max(rowHeight, size.height)
            isFirstInRow = false
        }
        maxRowWidth = max(maxRowWidth, x)
        totalHeight += rowHeight

        let width = proposal.width ?? maxRowWidth
        return CGSize(width: width, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        var isFirstInRow = true

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if !isFirstInRow, x + spacing + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + lineSpacing
                rowHeight = 0
                isFirstInRow = true
            }
            if !isFirstInRow {
                x += spacing
            }
            view.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width
            rowHeight = max(rowHeight, size.height)
            isFirstInRow = false
        }
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var tags = ["swiftui", "design", "forms"]
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Topics").font(.headline)
                TokenTagInputField(tokens: $tags, placeholder: "Add topic", maxTokens: 8)
                    .tint(.indigo)
                Text("\(tags.count) tags")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
        }
    }
    return PreviewHost()
}
