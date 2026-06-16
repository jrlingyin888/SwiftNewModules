import SwiftUI

/// The trailing affordance shown on the right side of a section header.
enum SectionHeaderTrailingActionKind {
    case text(String)
    case icon(String)
    case none
}

/// A section header with a left title (optional count) and a trailing action button.
struct SectionHeaderTrailingAction: View {
    let title: String
    var count: Int? = nil
    var action: SectionHeaderTrailingActionKind = .none
    var tint: Color = .accentColor
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            if let count {
                Text("\(count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .padding(.horizontal, 7)
                    .padding(.vertical, 1)
                    .background(.quaternary, in: Capsule())
            }

            Spacer(minLength: 8)
            trailingButton
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder private var trailingButton: some View {
        switch action {
        case .text(let label):
            Button(label) { onAction?() }
                .font(.subheadline.weight(.semibold))
                .tint(tint)
                .accessibilityHint("Shows all \(title.lowercased())")
        case .icon(let systemName):
            Button {
                onAction?()
            } label: {
                Image(systemName: systemName)
                    .font(.body.weight(.semibold))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .tint(tint)
            .accessibilityLabel(Text(title))
        case .none:
            EmptyView()
        }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeaderTrailingAction(title: "Recent", count: 8, action: .text("See All")) {}
                RoundedRectangle(cornerRadius: 12).fill(.quaternary).frame(height: 80)
            }
            VStack(alignment: .leading, spacing: 8) {
                SectionHeaderTrailingAction(title: "Favorites", action: .icon("plus.circle.fill"), tint: .pink) {}
                RoundedRectangle(cornerRadius: 12).fill(.quaternary).frame(height: 80)
            }
            VStack(alignment: .leading, spacing: 8) {
                SectionHeaderTrailingAction(title: "Archived")
                RoundedRectangle(cornerRadius: 12).fill(.quaternary).frame(height: 80)
            }
        }
        .padding()
    }
}
